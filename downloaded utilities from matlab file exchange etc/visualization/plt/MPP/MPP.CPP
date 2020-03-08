/* MPP.CPP: Matlab preprocessor ver 1.7    */
/* Paul Mennen (paul@mennen.org) 20-Dec-14 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include <math.h>
#include <time.h>

#define VERSION "1.7"
#define HASH_TBL_SIZE 1024
#define QT '\''
#define ASZ 120
#define BSZ 2000
/* #define UNIX 1 */         /* comment out for DOS */

enum boolean {FALSE, TRUE};
enum input_t {prog_file, include_file, string} input_type;
enum sym_t {
  define_sym, end_define_sym, include_sym, end_include_sym, comment_sym,
  ident_sym, quote_sym, number_sym, semicolon_sym, rparen_sym, lparen_sym,
  add_sym, sub_sym, mul_sym, div_sym, equal_sym, space_sym, period_sym,
  double_dots_sym, triple_dots_sym, lbracket_sym, rbracket_sym, 
  eoln_sym, eof_sym, a_sym} sym;
typedef enum sym_t sym_te;

char last_ch[4] = {0, 0, 0, 0}; /* last symbol read from input */
char ch;              /* next character to be parsed */
char prev_ch;         /* previous character parsed */
char ident[ASZ];      /* to collect characters while scanning an identifier */
char quote[BSZ];      /* to collect characters while scanning a quoted string */
char number[ASZ];     /* to collect characters while scanning a number */
char in_fname[ASZ];   /* main input file name */
char out_fname[ASZ];  /* output file name */
char ipath[ASZ];      /* contains drv:path\mpp.ini */
char inc_fname[ASZ];  /* include file name */
char *string_ptr;     /* points to input data when parsing from memory */
double lval = 0.0;    /* last result from eval */
int line = 1;         /* line number of main input file */
int iline = 0;        /* line number of include file (0 if not open) */
int pause_output = TRUE;     /* inhibit echoing of input chars to output file */
int pause_override = FALSE;  /* inhibit function of pause_output flag */
int in_define = FALSE;       /* true when scanning inside a define section */
int first_include_comment = FALSE;
FILE *infile   = NULL;   /* input from program file */
FILE *incfile  = NULL;   /* input from include file */
FILE *outfile  = NULL;   /* output file */
FILE *outfile2 = NULL;   /* output file 2 */

typedef struct list_struct  /* structure containing identifier information */
{ char *ident;              /* points to identifier name */
  char *val;                /* points to identifier character replacement */
  char is_numeric;          /* TRUE if identifier has a numeric value */
  double num_val;           /* numeric value of identifier if is_numeric=TRUE */
  struct list_struct *next; /* points to next identifier in the same */
                            /* hash table entry */
} list_t;

typedef list_t *list_ptr_t;
list_ptr_t hash_tbl[HASH_TBL_SIZE];    /* hash table */



/*************************************************************************/
/*       hash_val:  Computes hash table value from identifier string     */
/*************************************************************************/
unsigned int hash_val(char *str)
{ unsigned int val = 0;
  int len = strlen(str);
  int i;
  for (i = 0; i < len; i++)  val ^= str[i] << ((i & 1) ? 8 : 0);
  return(val);
}


/*************************************************************************/
/*            add_ident:  Adds an identier to the hash table             */
/*************************************************************************/
void add_ident(char *ident, char *val, char is_num)
{ int index = hash_val(ident) % HASH_TBL_SIZE;
  list_ptr_t new_node = (struct list_struct *) malloc(sizeof(list_t));

  new_node->ident = (char *) malloc(strlen(ident) + 1);
  strcpy(new_node->ident, ident);
  new_node->val = (char *) malloc(strlen(val) + 1);
  strcpy(new_node->val, val);
  new_node->is_numeric = is_num;
  new_node->next = hash_tbl[index];
  hash_tbl[index] = new_node;
}


/*************************************************************************/
/*        lookup:  Retrieve identifier info from the hash table          */
/*************************************************************************/
list_ptr_t lookup(char *ident)
{ int index = hash_val(ident) % HASH_TBL_SIZE;
  int i;
  list_ptr_t list_ptr = hash_tbl[index];

  i = strlen(ident) - 2;
  if (ident[i]=='_' && ident[i+1]=='_') {ident[i]=0; return(NULL);}
  while (list_ptr) { if (!strcmp(list_ptr->ident, ident)) break;
                     else  list_ptr = list_ptr -> next;
                   }
  return(list_ptr);
}

/*************************************************************************/
/*              init_hash_tbl:   Initializes the symbol table            */
/*************************************************************************/
void init_hash_tbl(void)
{ int i; char *p;
  for (i = 0; i < HASH_TBL_SIZE; i++)  hash_tbl[i] = NULL;
  strcpy(ident,in_fname);                      /* get input file name */
  if ((p=strrchr(ident,'.')) != NULL) *p = 0;  /* remove extension    */
  add_ident("FileName$",ident,0); /* predefined symbol: file name */
  add_ident("$$","\'",0);         /* predefined symbol: ' */
  add_ident("c$","%",0);          /* predefined symbol: % */
  add_ident("s$",";",0);          /* predefined symbol: ; */
}



/*************************************************************************/
/*              outch:   Output a character to the output file           */
/*              outstr:  Output a string to the output file              */
/*************************************************************************/
void outch(char ch)    { putc(ch, outfile); }
void outstr(char *str) { fputs(str, outfile); }

/**************************************************************************/
/*  getch: Get next char to be parsed into global ch; outputs prev. char  */
/**************************************************************************/
void getch(void)
{ static last_ch, last_inc_ch;

  prev_ch = ch;
  switch(input_type)
  { case prog_file:
      if (!pause_output) outch(last_ch);
      last_ch = ch = getc(infile);
      if (ch == '\n') line++;
      break;
    case include_file:
      if (first_include_comment) outch(last_inc_ch);
      last_inc_ch = ch = getc(incfile);
      if (ch == '\n') iline++;
      break;
    case string:  ch = *string_ptr++;  break;
  }
}

/****************************************************************************/
/* newch: Returns global ch, then updates ch to next character to be parsed */
/*        "a = newch()" is equivalent to "a = ch; getch()"                  */
/* **************************************************************************/
char newch(void)
{ char ch_save;
  ch_save = ch;
  getch();
  return(ch_save);
}    

/*************************************************************************/
/*  consume2eoln:  Consume characters (while outputing) to end of line   */
/*************************************************************************/
void consume2eoln(void) { while (ch != '\n') getch();  getch(); }

/*************************************************************************/
/*  match: looks for a specified string at current parse position        */
/*************************************************************************/
int match(char *str, int til_space)
{ int len = strlen(str);
  int i;

  for (i = 0; i < len; i++) { getch(); if (ch != str[i]) return(FALSE); }
  getch();
  if (til_space)        /* must be followed by space or eol */
  { if (ch != ' ' && ch != '\n') return(FALSE);
    getch();
  }
  return(TRUE);
}



/*************************************************************************/
/*   error:  Fatal error, prints message, then aborts                    */
/*************************************************************************/
void error(char *str)
{ char temp[ASZ];

  sprintf(temp,"\nMPP ERROR: %s\n   from input file '%s'  line #%d\n",
        str,in_fname,line - (iline ? 1 : 0));
  printf(temp);  outstr(temp);
  if (iline > 0)    /* if an include file is open */
  { sprintf(temp,"   from include file '%s'  line #%d\n",inc_fname,iline);
    printf(temp);  outstr(temp);
  }
  if (infile)  fclose(infile);  /* close any open files */
  if (outfile) fclose(outfile);
  if (incfile) fclose(incfile);
  exit(1);
}

/*************************************************************************/
/*  expect_error:  Fatal error, prints "expected" message, then aborts   */
/*************************************************************************/
void expect_error(char *str)
{ char temp[ASZ];
  sprintf(temp, "%s expected", str);  error(temp);
}



/*************************************************************************/
/*  getsym:  Returns the next symbol of the input stream                 */
/*           The result is also saved into the global variable "sym"     */
/*************************************************************************/
sym_te getsym(int skip_space)
{ char *p;
  static char sy[] = "; ()[]+-*/=\n";   /* special symbols */
  static sym_te syi[] = { semicolon_sym, space_sym, lparen_sym, rparen_sym,
                         lbracket_sym, rbracket_sym, add_sym, sub_sym,
                         mul_sym, div_sym, equal_sym, eoln_sym };
  static sym_te last_sym = a_sym;
  int i = 0;

beginning:
  if (skip_space) while (ch == ' ')  getch();

  last_ch[0] = ch;  last_ch[1] = 0;     /* last char and string terminator */
  if ((sym != space_sym) && (sym != comment_sym)) last_sym = sym;

  if ((p=strchr(sy,ch)) != NULL) { sym = syi[p-sy]; getch(); } /* specials */

  else if (  (ch >= 'a' && ch <= 'z')              /* identifier */
          || (ch >= 'A' && ch <= 'Z')
          ||  ch == '_' || ch == '$')
  { if (!pause_override) pause_output = TRUE;
    do ident[i++] = newch();
    while ( (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') ||
            (ch >= '0' && ch <= '9') ||  ch == '_' );
    if (ch == '$' | ch == '(')  /* ( may be the last character of identifier */
        ident[i++] = newch();   /* $ may be the 1st or last character */
    ident[i] = 0;
    sym = ident_sym;
  }

  else if (ch == '%') /* comment character -------------------------------- */
  { getch();
    if (ch=='d') sym = match("efine",TRUE) ? define_sym : comment_sym;
    else if (ch=='i') sym = match("nclude",TRUE) ? include_sym : comment_sym;
    else if (ch=='e')
    { if (match("nd_", FALSE))
      { if (ch=='i') sym = match("nclude",TRUE) ? end_include_sym : comment_sym;
        else if (ch=='d')
                  sym = match("efine",TRUE) ? end_define_sym : comment_sym;
      } else  sym = comment_sym;
    } else sym = comment_sym;
    if (sym == comment_sym) { consume2eoln(); sym = eoln_sym; }
  }   /* end if (ch == '%') */



  else if (ch >= '0' && ch <= '9')  /* number ----------------------------- */
  { while (1)
    { do number[i++] = newch(); while ( ch >= '0' && ch <= '9' ); /* digits */
      if (ch == '.') number[i++] = newch();                /* decimal point */
      else if(ch != 'e' && ch != 'E') break;               /* allow 1E7 */
      if (ch >= '0' && ch <= '9')                          /* decimals */
         do number[i++] = newch(); while ( ch >= '0' && ch <= '9' );
      if (ch=='e' || ch=='E') number[i++] = newch(); else break; /* exponent */
      if (ch=='-' || ch=='+') number[i++] = newch();       /* exponent sign */
      if (ch >= '0' && ch <= '9')  /* exponent */
         do number[i++] = newch(); while ( ch >= '0' && ch <= '9' );
      break;
    }  /* end while (1) */
    number[i] = 0;
    sym = number_sym;
  }  /* end else if (ch >= '0' && ch <= '9') */

  else if (ch == '.')  /* period ------------------------------------------ */
  { getch();
    if (ch == '.')              /* 2 dots ? */
    { getch();
      if (ch == '.')            /* 3 dots ? */
      { if (in_define)
        { consume2eoln();       /* if we are parsing a define, output a */
          outstr("%");          /* comment symbol on the continuation line */
          while (ch == ' ') getch(); /* skip the spaces on the next line */
          goto beginning;
        }
        else                    /* not in a define statement */
        { strcpy(last_ch, "...");       /* just returns "..." */
          sym = triple_dots_sym;
          getch();
        }
      }
      else { strcpy(last_ch, ".."); sym = double_dots_sym; }  /* 2 dots */
    }  /* end if (ch == '.') // 2 dots ? */
    else  sym = period_sym;  /* 1 dot */
  }  /* end else if (ch == '.') */

  else if (ch == QT) /* quote ------------------------------------------ */
    if (prev_ch != ' ' &&
         (last_sym==rbracket_sym  ||             /* it's a transpose: [..]' */
          last_sym==rparen_sym    ||             /* it's a transpose: (..)' */
          (last_sym==ident_sym && strcmp(ident,"$$"))))  /* a transpose: x' */
    { sym = a_sym; getch(); }                    /* here for transpose */
    else                                         /* here for quoted string */
    { do { do { quote[i++] = newch();
                if (i >= BSZ)
                { quote[46]=0;
                  error(strcat("Unmatched quoted string at: ",quote));
                }
              } while (ch != QT);
           quote[i++] = newch();
         } while (ch == QT);
      quote[i] = 0;
      sym = quote_sym;
    }  /* end if (prev_ch != ' ') ... else ... */
  else if (ch == EOF)  sym = eof_sym; /* end of file ---------------------- */
  else { sym = a_sym;  getch();  }  /* everything else -------------------- */
  return(sym);
}  /* end getsym */



int expression(double *result);

/*************************************************************************/
/*  factor: result = one factor of a product (a number or the result     */
/*                   of a expresstion surrounded by parenthesis)         */
/*          returns TRUE if it is a factor, FALSE otherwise              */
/*************************************************************************/
int factor(double *result)
{ double f;
  int success;

  switch(sym)
  { case number_sym:  getsym(TRUE);
                      *result = atof(number);
                      return(TRUE);
    case lparen_sym:  getsym(TRUE);
                      if ((success = expression(&f)) == TRUE) *result = f;
                      if (sym == rparen_sym) getsym(TRUE);
                      else expect_error("right parenthesis");
                      return(success);
    default:          return(FALSE);
  }
}


/*************************************************************************/
/*  term:  result = one term of a sum (a number or the product of two or */
/*         more numbers)                                                 */
/*         returns TRUE if it is a term, FALSE otherwise                 */
/*************************************************************************/
int term(double *result)
{ int success;
  double f, acc;

  if ((success = factor(&f)) == TRUE) acc = f;
  while (success && (sym == mul_sym || sym == div_sym))
  { int mul;
    mul = (sym == mul_sym);
    getsym(TRUE);
    if ((success = factor(&f)) == TRUE) { if (mul) acc *= f; else acc /= f; }
  }
  if (success) *result = acc;
  return(success);
}



/*************************************************************************/
/*  expression:  result = a term or the sum of two or more terms         */
/*               returns TRUE if it is an expression, FALSE otherwise    */
/*************************************************************************/
int expression(double *result)
{ int success;
  double f, acc;

  if (sym == add_sym || sym == sub_sym)
  { int neg;
    neg = (sym == sub_sym);
    getsym(TRUE);
    if ((success = term(&f)) == TRUE) acc = neg ? -f : f;
  }
  else if ((success = term(&f)) == TRUE) acc = f;
  while (success && (sym == add_sym || sym == sub_sym))
  { int add;
    add = (sym == add_sym);
    getsym(TRUE);
    if ((success = term(&f)) == TRUE) { if (add) acc += f; else acc -= f; }
  }
  if (success) *result = acc;
  return(success);
}


/***************************************************************************/
/* eval: Evaluate the arithmetic expression at *expr.                      */
/*       if it's an expression, returns TRUE & leaves its value in *expr   */
/*       if it's not an expression, returns FALSE & does not modify *expr  */
/***************************************************************************/
int eval(char *expr)
{ int success;
  char save_ch;
  enum input_t save_input_type;

  save_ch = ch;
  save_input_type = input_type;
  string_ptr = expr;
  input_type = string;
  getch();
  getsym(TRUE);

  if ((success = expression(&lval)) == TRUE) sprintf(expr, "%1.13g", lval);

  input_type = save_input_type;
  ch = save_ch;
  return(success);
}



/***************************************************************************/
/* pick_vec: returns one element from the vector pointed to by *p in the   */

/*           form: [a, b, c, ... ].  (semicolons may be used instead of ,) */
/*           The vector index is taken from the input text stream          */
/***************************************************************************/
char *pick_vec(char *p)
{ static char elem[ASZ];      /* Must be static. Returns function result. */
  char delim = ',';           /* first assume its a row vector */
  int i;

  i = newch() - '0';                       /* get 1st digit of vector index */
  if (ch != ')') i = 10*i + newch() - '0'; /* get 2nd digit of vector index */
  if (ch != ')') error("vector index must be 1 or 2 digits");
  if (i <= 0 || i > 99) error("vector index must be between 1 and 99");
  getch();                                 /* skip right paren */
  p++;                                     /* skip left bracket */
  if (!strchr(p,delim)) delim = ';';       /* assume column vector if no , */
  while (--i)  /* search for the ith element using delimiter delim */
      if ((p=strchr(p,delim)) == NULL)
         error("vector index > # of vector elements");
      else p++;
  while (*p != delim && *p != ']') elem[i++] = *p++;
  elem[i] = 0;
  return(elem);
}


/*************************************************************************/
/* parse_expr: Handles expressions of the form "identifier = expression" */
/*************************************************************************/
char *parse_expr(int *is_numeric, int isdefine)
{ static char expr[BSZ];      /* Must be static. Returns function result. */
  char expr2[BSZ], *p, *q, *qs;
  int i;
  int evaluate = TRUE;
  list_ptr_t list_ptr;
  char terminator[5];
  int nested_brackets = 0;

  if(isdefine)
  { getsym(TRUE);
    if (sym == semicolon_sym || sym == a_sym)  /* auto-increment definition */
    { *is_numeric = 1; sprintf(expr, "%1.13g", lval=lval+1.0); return(expr); }
    if (sym != equal_sym) expect_error("equal sign (=)");
    in_define = TRUE;
    getsym(TRUE);
  }
  expr[0] = 0;



  while ((sym != semicolon_sym && sym != eoln_sym) || nested_brackets > 0)
  { if (strlen(expr) > BSZ-ASZ)
    { expr[46]=0;  error(strcat("Unmatched bracket in define at:",expr)); }
    switch(sym)
    { case ident_sym:
        if ((list_ptr = lookup(ident)) != NULL)  /* is identifier in table? */
        { strcat(expr, list_ptr -> val);                /* yes (non vector) */
          if (!list_ptr -> is_numeric) evaluate = FALSE;
        }
        else                                               /* No, not found */
        { i = strlen(ident) - 1;
          if (ident[i] == '(')                /* No. Does it end with a ( ? */
          { ident[i] = 0;  sym = lparen_sym;  /* Yes, remove the trailing ( */
            if ((list_ptr = lookup(ident)) != NULL)  /* Is it in the table? */
            { p = list_ptr -> val;                       /* get its value */
              if (*p == '[') strcat(expr,pick_vec(p));   /* its a vector */
              else { strcat(expr,p);  strcat(expr,"("); evaluate=FALSE; }
            }
            else { strcat(expr,ident); strcat(expr,"("); evaluate=FALSE; }
          }
          else { strcat(expr,ident); evaluate=FALSE; }   /* ident undefined */
        }
        break;
      case number_sym:  strcat(expr, number);  break;
      case quote_sym:  strcat(expr, quote);  evaluate = FALSE;  break;
      case lbracket_sym: case rbracket_sym:
        nested_brackets += (sym==lbracket_sym) ? 1 : -1; 
        evaluate = FALSE;               /* note fall thru */
      case lparen_sym: case rparen_sym:
      case add_sym: case sub_sym: case mul_sym: case div_sym:
      case space_sym:  strcat(expr, last_ch);  break;
      default:  evaluate = FALSE;
                if (isdefine) strcat(expr, last_ch); else goto out_loop;
    } /* end switch */
    if (ch == '%') goto out_loop;
    getsym(FALSE);
  }  /* end while */

out_loop:
  if (isdefine) { i = strlen(expr) - 1;    /* trim trailing space */
                  while (i >= 0 && expr[i] == ' ') expr[i--] = 0;
                }
  else strcpy(terminator, last_ch);

  in_define = FALSE;   *is_numeric = evaluate && eval(expr);

  /* evaluate each element of a vector */
  if (isdefine && *expr == '['    /* IF  its a vector being defined   */
      && !strchr(expr+1,'[')      /* AND there are no nested brackets */
      && !strchr(expr,QT)         /* AND there are no quotes inside   */
      && *(expr+2))               /* AND expr != [] (> 2 characters)  */
  { p = expr; q = expr2; *q++ = *p++;  /* move 1st character (the '[') */
    while (*p)                         /* do until end of 'expr' is reached */
    { qs=q;
      while(!strchr(",;:]",*p)) *qs++ = *p++; /* move from expr to expr2 */
      *qs=0; eval(q); while (*++q); *q++ = *p++; /* evaluate it, attach delim */
    }
    *q = 0;  strcpy(expr,expr2);       /* move result back to expr */
  }
  if (!isdefine) strcat(expr, terminator);
  return(expr);
}



/*************************************************************************/
/*  open_inc_file:  Go thru various search methods to find the include   */
/*                  file whose name is in global inc_fname               */
/*************************************************************************/
FILE *open_inc_file(void)
{ FILE *inc_f, *ini_f;
  char path[ASZ];

  inc_f = NULL;                         /* initialize to indicate error */
  if (!strrchr(inc_fname, '.'))
    strcat(inc_fname, ".m");        /* assume .m extension if none present */

  if ((inc_f = fopen(inc_fname,"rt")) != NULL)
      return(inc_f);  /* return if include file was found in local directory */
  /* since include file was not in local directory, look for mpp.ini */
  ini_f = fopen("mpp.ini", "rt");  /* 1st look for mpp.ini in local directory */
  if (!ini_f) ini_f = fopen(ipath,"rt"); /* then look where mpp.exe is */
  if (!ini_f) error("Unable to find mpp.ini");
  do
  { if (fgets(path, sizeof(path), ini_f) == NULL) break; /* check for EOF */
    if (strlen(path) > 0)        /* if needed, strip eoln and/or append '\' */
    { if (path[strlen(path) - 1] == '\n') path[strlen(path) - 1] = 0;
      #ifdef UNIX     /* For UNIX: Use forward slash */
      if (path[strlen(path) - 1] != '/') strcat(path, "/");
      #else           /* For DOS: Use backslash */
      if (path[strlen(path) - 1] != '\\') strcat(path, "\\");
      #endif
    }
    strcat(path, inc_fname);
    inc_f = fopen(path, "rt");
  } while (!inc_f);
  fclose(ini_f);
  if (!inc_f)
  { char err[ASZ];
    sprintf(err, "Unable to open include file: %s", inc_fname);
    iline = -1;  error(err);
  }
  return(inc_f);
}



/*************************************************************************/
/*  process_include: Scan thru include file while saving identifier info */
/*************************************************************************/
void process_include(void)
{ char save_ch = ch;
  char id[ASZ];
  char *val;
  int is_numeric;
  enum input_t save_input_type = input_type;

  incfile = open_inc_file();
  iline = 1;
  input_type = include_file;
  getch();
  if (ch == '%') first_include_comment = TRUE;
  else { outstr("% "); sprintf(id, "%s;\n", inc_fname);  outstr(id); }
  getsym(TRUE);
  first_include_comment = FALSE;

  while (sym != eof_sym)
  { if (sym == ident_sym)
    { strcpy(id, ident);                /* save the identifier's name */
      val = parse_expr(&is_numeric, TRUE);
      add_ident(id, val, is_numeric);
    }
    getsym(TRUE);
  }  /* end   while (sym != eof_sym); */
  ch = save_ch;
  input_type = save_input_type;
  fclose(incfile);
  iline = 0;
}



/*************************************************************************/
/* parse:  All the real work happens here. Scans input & writes output.  */
/*************************************************************************/
void parse(void)
{ char id[BSZ], *p;
  list_ptr_t list_ptr;
  int i, is_numeric;
  char *val;

  while (sym != eof_sym)
  switch (sym)
  { case define_sym:  /* ----------------------------- DEFINE SECTION ----- */
      while (getsym(TRUE) == eoln_sym);
      while (sym == ident_sym)
      { outstr("%"); outstr(strcpy(id, ident));  /* save identifier's name */
        pause_output = FALSE;
        pause_override = TRUE;
        val = parse_expr(&is_numeric, TRUE);
        add_ident(id, val, is_numeric);
        pause_override = FALSE;
        while (getsym(TRUE) == eoln_sym);
      } /* end while (sym == ident_sym) */
      if (sym != end_define_sym) expect_error("%%end_define");
      getsym(TRUE);
      break;  /* end case define_sym */

    case include_sym:  /* ---------------------------- INCLUDE SECTION ---- */
      pause_output = TRUE;
      while (getsym(TRUE) == eoln_sym) outstr("\n");
      while (sym == ident_sym)
      { strcpy(inc_fname, ident);
        if (getsym(FALSE) == period_sym)
        { strcat(inc_fname, ".");
          if (getsym(FALSE) == ident_sym) strcat(inc_fname, ident);
        }
        if (sym != eoln_sym) consume2eoln();
        process_include();
        while (getsym(TRUE) == eoln_sym) outstr("\n");
      }  /* end while (sym == ident_sym) */
      pause_output = FALSE;
      if (sym != end_include_sym) expect_error("%%end_include");
      outstr("%end_include\n");
      getsym(TRUE);
      break;  /* end case include_sym */



    case ident_sym:  /* ------------------------------ IDENTIFIERS -------- */
      if ((list_ptr = lookup(ident)) != NULL)  /* is identifier in table? */
        outstr(list_ptr -> val);               /* yes (non vector) */
      else                                     /* No, not found */
      { i = strlen(ident) - 1;
        if (ident[i] == '(')                /* No. Does it end with a ( ? */
        { ident[i] = 0;  sym = lparen_sym;  /* Yes, remove the trailing ( */
          if ((list_ptr = lookup(ident)) != NULL)  /* Is it in the table? */
          { p = list_ptr -> val;                   /* get its value */
            if (*p == '[') outstr(pick_vec(p));    /* its a vector */
            else { outstr(p);  outch('('); }
          }
          else { outstr(ident);  outch('('); }
        }
        else outstr(ident);                        /* ident undefined */
      }
      pause_output = FALSE;
      if (getsym(TRUE) == equal_sym)    /* simplify "ident = expression" */
      { pause_output = TRUE;            /* when found outside defines */
        while (getsym(FALSE) == space_sym) outstr(last_ch);
        outstr(parse_expr(&i, FALSE));
        pause_output = FALSE;
        getsym(TRUE);
      }
      break;  /* end case ident_sym */

    default: getsym(TRUE);  /* ------------------- ALL OTHER SYMBOLS ------- */
  }  /* end switch & while (sym != eof_sym) */
}


/*************************************************************************/
/*     stripcom: Remove comments from character string *s                */
/*************************************************************************/
void stripcom(char *s)
{  char *p, *q, e[BSZ];
   p=strcpy(e,s);          /* make a copy of the line */
   while(*p && *p != '%')  /* remove all quoted strings from the copy */
   { q = (p==e) ? p : p-1; /* use previous char to detect transpose operator */
     if ((*p == QT) &&     /* detect quoted string and replace it with colons */
         (*q != ']')  &&  (*q != ')')  &&  (*q != '_') &&
         ((*q < 'a') || (*q > 'z')) && ((*q < 'A') || (*q > 'Z')))
     do { do *p++ = ':'; while (*p != QT); *p++ = ':'; } while (*p == QT);
     else p++;
   }
   if (p-e >= BSZ) { *(s+50)=0; error(strcat("Unmatched quotes at: ",s)); }
   p = strchr(e,'%');       /* find first comment character */
   if (p)                   /* here if the line contains a comment */
   { p += s - e;                      /* point to comment in *s */
     while (p>s && *(p-1)==' ') p--;  /* remove trailing white space */
     if (p==s) {*s = '%'; p=s+1; }    /* avoid creating a blank line */
    *p++ = '\n';  *p = 0;             /* terminate the line */
   }
}


/*************************************************************************/
/*     usage: Display MPP usage                                          */
/*************************************************************************/
void usage(void)
{ printf("\nMPP, version %s, by Paul Mennen -------------------------",VERSION); 
  printf("\nSend questions or bug reports to me at paul@mennen.org\n");
  printf("\nUsage:  MPP INFILE [OUTFILE] [-s]");
  printf("\n        -s switch means comments are striped from output file\n");
  exit(1);
}

/*************************************************************************/
/*     main: Process command line arguments, Open input & output files   */
/*************************************************************************/
void main(int argc, char *argv[])
{ char *p, sv_fname[ASZ], e[BSZ];
  int strip_comments = 0;
  int a = 1;    /* point to first arguement */
  int hlp = -1;

  argc = argc - 2;  /* argc is number of arguments not including INFILE */
  if (argc < 0) usage();    /* must have at least one argument */
  strcpy(ipath,argv[0]);         /* get path\mpp.exe (UNIX: path/mpp) */
  #ifdef UNIX     /* just append .ini to the end */
  strcat(ipath,".ini");                  /* ipath = path/mpp.ini */
  #else           /* for DOS we must remove the exe first */
  strcpy(strstr(ipath,"MPP"),"MPP.INI"); /* ipath = path\mpp.ini */
  #endif

  if (*argv[a] == '-')  { strip_comments=1; a++; if(--argc < 0) usage(); }

  if (!strchr(strcpy(in_fname,argv[a++]),'.')) strcat(in_fname,".mi");
  if ((infile = fopen(in_fname, "rt")) == NULL)
  { printf("\nUnable to open input file %s\n", in_fname);  exit(1); }

  if (argc && (*argv[a] == '-')) { strip_comments=1; a++; argc--; }

  if (argc)                    /* output filename specified */
  { if (!strchr(strcpy(out_fname,argv[a++]),'.'))   /* if no extention */
      strcat(out_fname,".m");                       /* assume ".m"     */
    argc--;
  }
  else          /*if no output filename base it on input filename */
  { if ((p = strrchr(strcpy(out_fname,in_fname),'.')) != NULL)
    /* if input extension is ".m", output to "mpp.m" */
    if (strcmp(p,".m")==0 || strcmp(p,".M")==0) strcpy(out_fname, "mpp.m");
    else { *p = 0; strcat(out_fname, ".m"); } /* default to ".m" extension */
  }

  if (argc && (*argv[a] == '-')) strip_comments=1;



  strcpy(sv_fname,out_fname);

  if (strip_comments)
  { if ((outfile2 = fopen(out_fname, "wt")) == NULL)
    { printf("\nUnable to open output file %s\n", out_fname);  exit(1); }
    p = out_fname + strlen(out_fname) - 1;  /* point to last character */
    *p = '~';  /* outfile will be temp file. Last char changed to tilde */
  }

  if ((outfile = fopen(out_fname, "wt")) == NULL)
  { printf("\nUnable to open output file %s\n", out_fname);  exit(1); }

  init_hash_tbl();
  input_type = prog_file;
  getch();  pause_output = FALSE;  getsym(TRUE);  parse();
  fclose(infile);  fclose(outfile);

  if (strip_comments)
  { if ((infile = fopen(out_fname, "rt")) == NULL)
    { printf("\nUnable to open file %s\n", out_fname);  exit(1); }
      line = 1;
      while(fgets(e,BSZ,infile))    /* read a line, stop at end of file */
      { if (*e != '%') hlp++;       /* are we are past the help section? */
        if (hlp) stripcom(e);       /* if yes, remove comments */
        fputs(e,outfile2); line++;  /* output the line, sans comment */
      }
    fclose(infile);  fclose(outfile2);  remove(out_fname);
  }

  printf("\nMPP output written to file %s\n", sv_fname);
  exit(0);
} /* end main,   end MPP.CPP */


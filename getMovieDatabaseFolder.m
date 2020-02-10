function movieDatabaseFolder = getMovieDatabaseFolder()

    configValues = csv2cell('ComputerFolders.csv', 'fromfile');
    movieDatabaseFolder= getConfigValue(configValues, 'DropboxFolder');

end
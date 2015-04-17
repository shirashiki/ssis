## File Tracker
A demo ssis project to track and manage files in your computer.

The idea is to provide you a SSIS project you can see working. For this, you need a data source, and this case, will be your disk. This solutions is not intended to track files, the idea here is to demo some MS BI features.

## Use Cases

### Get files and folders

Execute a DOS DIR, saving the content in a file.
```
dir /s > filelist.txt
```

#### Package: get_filelist



#File functions

GetFileName = function(path)
{
  DirectorySeparatorChar = '\\'
  AltDirectorySeparatorChar = '/'
  VolumeSeparatorChar = ':'
  
  if (is.null(path))
  {
    return (NULL)
  }
  
  #   CheckInvalidPathChars(path);
  length = Length(path);
  index = length;
  
  repeat
  { 
    index = index - 1;
    if (index < 0)
    {
      return (path);
    }
    character = Substring(path, index, 1)
    
    if( FALSE
        || character == DirectorySeparatorChar 
        || character == AltDirectorySeparatorChar
        || character == VolumeSeparatorChar
    ){
      break
    }
  }
  
  path = Substring(path, index + 1, length - index - 1)
  return (path)
}

GetFileNameWithoutExtension<-function(path)
{
  path = GetFileName(path);
  if (is.null(path))
  {
    return (NULL);
  }
  else
  {
    index = LastIndexOf(path, '.');
    if (index != -1)
    {
      result = Substring(path, 0, index);
      return (result);
    }
    else
    {
      return (path);
    }
  }
}

# CheckInvalidPathChars=function(path)
# {
#   index = 0
#   length = Length(path)
#   while (index < length)
#   {
#     character = Substring(path, index, 1)
#     if (character == 34 || character == 60 || character == 62 || character == 124 || character < 32)
#     {
#       stop("Invalid characters in path")
#     }
#     index = index + 1
#   }
# }

# join two segments of a file path, checking for directory seperators
PathCombine = function( path1,  path2)
{
  return (file.path(path1, path2))
}


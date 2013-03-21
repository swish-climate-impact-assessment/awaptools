
# String functions
LastIndexOf = function(string, value)
{ 
  index = max(which(strsplit(string, '')[[1]]==value)) - 1
  if(index<0)
  {
    index = -1;
  }
  return (index);
}

Length = function(string)
{
  result = nchar(string);
  return (result);
}

Substring = function(string, startIndex, length)
{
  startIndex = startIndex;
  endIndex = startIndex + length;
  result = substr(string, startIndex + 1, endIndex);
  return (result);
}

[Debug]
-- Directories only used when building with Debug configuration

*.inc = obj\debug
*.clw = obj\debug
*.exp = obj\debug


[Release]
-- Directories only used when building with Release configuration

*.inc = obj\release
*.clw = obj\release
*.exp = obj\release

{include %bin%\Clarion90.RED}

[Common]
*.ico = .\resources; 
*.bmp = .\resources; 
*.jpg = .\resources; 
*.gif = .\resources; 
*.clw = _classes
*.inc = _classes

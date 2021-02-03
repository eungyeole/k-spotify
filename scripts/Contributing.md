# Contributing for scripts

## When adding new theme, Do theese things
- Under `# Select Theme to use` (Line 5), there is user input and verify.   Add new theme name (=need to be same as folder name) to `[ValidateSet("name1","name2","name3")`, and also on `'Input Theme name to use! name1 | name2 | name3 '`

- Under `# Delete files from K-theme` (Line 20), add this (replace Theme-Folder-Name to its name)
```powershell
if (Test-Path $sp_dir\Theme-Folder-Name) {
  Write-Part "REMOVING       "; Write-Emphasized $sp_dir\Theme-Folder-Name
  Remove-Item $sp_dir\Theme-Folder-Name -recurse 
  Write-Done
}
```


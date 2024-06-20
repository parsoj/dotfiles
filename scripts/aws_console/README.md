
## TODOs
- implement taskfile/makefile that will build the shiv, and install locally
- implement fish completions for this
- make it clean up the old chrome processes

## steps

# Add to pyproject.toml:
```
[tool.poetry.scripts]
aws_console = "aws_console:main"
```


# run this command to bundle into pyz:
(need shiv installed)
```
 poetry run shiv -c aws_console -o aws_console.pyz . 
```

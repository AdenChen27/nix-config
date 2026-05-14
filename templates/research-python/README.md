# Python Research Project

This template uses Nix to pin Python and system tools, and `uv` to manage Python dependencies.

```sh
direnv allow
uv sync --group dev
python -m ipykernel install --user --name "$(basename "$PWD")"
```

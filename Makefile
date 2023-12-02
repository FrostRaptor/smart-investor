install: ## Install the poetry environment.
	@echo "🚀 Creating virtual environment using pyenv and poetry"
	@poetry install --with dev --with docs
	@poetry shell

format: ## Format code using isort and black.
	@echo "🚀 Formatting code: Running isort and black"
	@poetry run isort .
	@poetry run black .

check: ## Check code formatting using isort, black and mypy.
	@echo "🚀 Checking code formatting: Running isort"
	@poetry run isort --check-only --diff .
	@echo "🚀 Checking code formatting: Running black"
	@poetry run black --check .
	@echo "🚀 Checking code formatting: Running mypy"
	@poetry run mypy .

test: ## Test the code with pytest.
	@echo "🚀 Testing code: Running pytest"
	@poetry run pytest --doctest-modules

commit: ## Create a new commit using commitizen.
	@echo "🚀 Creating a new commit"
	@poetry run cz commit

bump: ## Bump a new version based on the commits.
	@echo "🚀 Bumping a new version"
	@poetry run cz bump

build: clean-build ## Build wheel file using poetry.
	@echo "🚀 Creating wheel file"
	@poetry build

clean-build: ## Clean build artifacts.
	@rm -rf dist

publish: ## Publish a release to pypi.
	@echo "🚀 Publishing: Dry run."
	@poetry config pypi-token.pypi $(PYPI_TOKEN)
	@poetry publish --dry-run
	@echo "🚀 Publishing."
	@poetry publish

build-and-publish: build publish ## Build and publish.

docs-test: ## Test if documentation can be built without warnings or errors.
	@mkdocs build -s

docs: ## Build and serve the documentation.
	@mkdocs serve

.PHONY: docs

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

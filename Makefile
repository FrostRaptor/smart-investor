.PHONY: install
install: ## Install the poetry environment and the pre-commit hooks.
	@echo "🚀 Creating virtual environment using pyenv and poetry"
	@poetry install --with dev --with docs
	@poetry run pre-commit install
	@poetry shell

.PHONY: check
check: ## Check code formatting using ruff and mypy.
	@echo "🚀 Checking Poetry lock file consistency with 'pyproject.toml': Running poetry lock --check"
	@poetry check --lock
	@echo "🚀 Linting code: Running pre-commit"
	@poetry run pre-commit run -a

.PHONY: test
test: ## Test the code with pytest.
	@echo "🚀 Testing code: Running pytest"
	@poetry run pytest --cov --cov-config=pyproject.toml --cov-report=xml
	@poetry run pytest --doctest-modules

.PHONY: commit
commit: ## Create a new commit using commitizen.
	@echo "🚀 Creating a new commit"
	@poetry run cz commit

.PHONY: bump
bump: ## Bump a new version based on the commits.
	@echo "🚀 Bumping a new version"
	@poetry run cz bump

.PHONY: build
build: clean-build ## Build wheel file using poetry.
	@echo "🚀 Creating wheel file"
	@poetry build

.PHONY: clean-build
clean-build: ## Clean build artifacts.
	@rm -rf dist

.PHONY: publish
publish: ## Publish a release to pypi.
	@echo "🚀 Publishing: Dry run."
	@poetry config pypi-token.pypi $(PYPI_TOKEN)
	@poetry publish --dry-run
	@echo "🚀 Publishing."
	@poetry publish

.PHONY: build-and-publish
build-and-publish: build publish ## Build and publish.

.PHONY: docs-test
docs-test: ## Test if documentation can be built without warnings or errors.
	@poetry run mkdocs build -s

.PHONY: docs
docs: ## Build and serve the documentation.
	@poetry run mkdocs serve

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

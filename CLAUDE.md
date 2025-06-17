# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Elixir library that provides Phoenix components for Lucide icons. The library dynamically generates Phoenix components from Lucide SVG icons at compile time.

## Development Commands

### Basic Commands
- **Install dependencies**: `mix deps.get`
- **Run tests**: `mix test`
- **Run a specific test**: `mix test test/lucide_icons_test.exs:7` (line number)
- **Format code**: `mix format`
- **Check formatting**: `mix format --check-formatted`
- **Compile with warnings as errors**: `mix compile --warnings-as-errors`
- **Generate documentation**: `mix docs`

### Node.js Dependencies
The project depends on the `lucide-static` npm package which contains the SVG icon files:
- Icon SVGs are located in `priv/node_modules/lucide-static/icons/*.svg`
- To update icons: modify the version in `priv/package.json` and run `cd priv && npm install`

## Architecture

### Icon Generation Flow
1. **Build-time generation**: Icons are parsed and components are generated at compile time
2. **SVG parsing**: `Lucideicons.Icon.parse!/1` reads SVG files from `priv/node_modules/lucide-static/icons/`
3. **Component creation**: For each icon, a Phoenix component function is dynamically created
4. **Name transformation**: Icon filenames are converted from kebab-case to snake_case (e.g., `alert-triangle.svg` → `alert_triangle`)

### Key Modules
- `Lucideicons`: Main module that defines all icon components using Phoenix.Component
- `Lucideicons.Icon`: Handles SVG parsing, attribute handling, and icon data structure

### Important Implementation Details
- Uses `@external_resource` to track SVG files and trigger recompilation when icons change
- Supports all HTML attributes through dynamic attribute handling
- Maintains the original Lucide SVG structure while allowing Phoenix-style attributes
- Automatically detects and uses available JSON library (JSON or Jason)
- Version tracking of lucide-static dependency is embedded in generated icons

## Testing Approach
Tests use `Phoenix.LiveViewTest` to render components and verify:
- Basic icon rendering
- HTML attribute support (class, aria attributes, etc.)
- Attribute name conversion (snake_case to kebab-case)

## Automated Updates & Releases

### Update Workflow
The project uses GitHub Actions to automatically check for lucide-static updates:
- **Schedule**: Runs weekly (Mondays at 9 AM UTC)
- **Manual trigger**: Can be run manually via GitHub Actions UI
- **Process**:
  1. Checks npm for new lucide-static versions
  2. Creates a PR with updates if available
  3. Runs tests to ensure compatibility
  4. Bumps project version automatically

### Release Workflow
Releases are automated when a version tag is pushed:
- **Trigger**: Push tag matching `v*.*.*` pattern
- **Process**:
  1. Verifies tag version matches mix.exs
  2. Runs full test suite
  3. Publishes to Hex.pm
  4. Creates GitHub release

### Mix Tasks
- `mix lucide_icons.check_updates` - Check if lucide-static has updates available (uses Req for HTTP requests)
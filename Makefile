.PHONY: all run run-dev run-prod build clean get analyze test lint format build_runner_watch build_runner_build l10n copy-db

# Default run command, runs the dev flavor.
# Use `make run-dev` or `make run-prod` to be explicit.
run: run-dev

run-dev:
	flutter run --flavor dev

run-prod:
	flutter run --flavor prod

build:
	flutter build apk

analyze:
	flutter analyze

test:
	flutter test

clean:
	flutter clean

get:
	flutter pub get

build_runner:
	flutter pub run build_runner build --delete-conflicting-outputs

l10n:
	flutter gen-l10n --arb-dir=l10n \
		--output-localization-file=app_localizations.dart \
		--output-dir=lib/generated/l10n

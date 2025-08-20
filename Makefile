.PHONY: all run run-dev run-prod build clean get analyze test lint format build_runner_watch build_runner_build l10n copy-db

# Default run command, runs the dev flavor.
# Use `make run-dev` or `make run-prod` to be explicit.
# You need to have GOOGLE_PLACES_API_KEY environment variable set.
# Example: export GOOGLE_PLACES_API_KEY="your_api_key"
run: run-dev

run-dev:
	flutter run --flavor dev --dart-define=GOOGLE_PLACES_API_KEY=$(GOOGLE_PLACES_API_KEY)

run-prod:
	flutter run --flavor prod --dart-define=GOOGLE_PLACES_API_KEY=$(GOOGLE_PLACES_API_KEY)

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

distribute-dev:
	flutter build apk --flavor dev
	firebase appdistribution:distribute build/app/outputs/flutter-apk/app-dev-release.apk --app $(FIREBASE_APP_ID_DEV) --groups "testers"

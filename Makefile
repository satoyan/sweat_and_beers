.PHONY: all run run-dev run-prod build clean get analyze test lint format build_runner_watch build_runner_build l10n copy-db

# Default run command, runs the dev flavor.
# Use `make run-dev` or `make run-prod` to be explicit.
# You need to have GOOGLE_PLACES_API_KEY environment variable set.
# Example: export GOOGLE_PLACES_API_KEY="your_api_key"
run: run-local

run-simple:
	flutter run --flavor local \
		--dart-define=GOOGLE_PLACES_API_KEY=$(GOOGLE_PLACES_API_KEY) \
		--dart-define=GOOGLE_AD_UNIT_ID_IOS=$(GOOGLE_AD_UNIT_ID_IOS) \
		--dart-define=GOOGLE_AD_UNIT_ID_ANDROID=$(GOOGLE_AD_UNIT_ID_ANDROID)

run-local:
	flutter run --flavor local \
		--dart-define=GOOGLE_PLACES_API_KEY=$(GOOGLE_PLACES_API_KEY) \
		--dart-define=GOOGLE_AD_UNIT_ID_IOS=$(GOOGLE_AD_UNIT_ID_IOS) \
		--dart-define=GOOGLE_AD_UNIT_ID_ANDROID=$(GOOGLE_AD_UNIT_ID_ANDROID) \
		--dart-define=FULL_FEATURE_ENABLED=true

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

distribute-dev-android:
	flutter build apk --release \
		--flavor dev \
		--dart-define=GOOGLE_PLACES_API_KEY=$(GOOGLE_PLACES_API_KEY) \
		--dart-define=GOOGLE_AD_UNIT_ID_IOS=$(GOOGLE_AD_UNIT_ID_IOS) \ 
		--dart-define=GOOGLE_AD_UNIT_ID_ANDROID=$(GOOGLE_AD_UNIT_ID_ANDROID) 

	firebase appdistribution:distribute build/app/outputs/flutter-apk/app-dev-release.apk --app $(ANDROID_FIREBASE_APP_ID_DEV) --groups "testers"

distribute-dev-ios:
	flutter build ipa --release \
		--flavor dev \
		--export-options-plist=ios/ExportOptions-dev.plist \
		--dart-define=GOOGLE_PLACES_API_KEY=$(GOOGLE_PLACES_API_KEY) \
		--dart-define=GOOGLE_AD_UNIT_ID_IOS=$(GOOGLE_AD_UNIT_ID_IOS) \ 
		--dart-define=GOOGLE_AD_UNIT_ID_ANDROID=$(GOOGLE_AD_UNIT_ID_ANDROID) 

	firebase appdistribution:distribute build/ios/ipa/Sweat\ \&\ Beers.ipa \
		--app $(IOS_FIREBASE_APP_ID_DEV) \
		--groups "testers"

build_aab_dev:
	flutter build appbundle \
		--flavor prod \
		--release \
		--dart-define=GOOGLE_PLACES_API_KEY=$(GOOGLE_PLACES_API_KEY) \
		--dart-define=GOOGLE_AD_UNIT_ID_IOS=$(GOOGLE_AD_UNIT_ID_IOS) \ 
		--dart-define=GOOGLE_AD_UNIT_ID_ANDROID=$(GOOGLE_AD_UNIT_ID_ANDROID)\
		--dart-define=FULL_FEATURE_ENABLED=true

build_aab_dev-simple:
	flutter build appbundle \
		--flavor prod \
		--release \
		--dart-define=GOOGLE_AD_UNIT_ID_IOS=$(GOOGLE_AD_UNIT_ID_IOS) \ 
		--dart-define=GOOGLE_AD_UNIT_ID_ANDROID=$(GOOGLE_AD_UNIT_ID_ANDROID)\
		--dart-define=GOOGLE_PLACES_API_KEY=$(GOOGLE_PLACES_API_KEY)

build_ipa_release:
	flutter build ipa --release \
		--export-options-plist=ios/ExportOptions-release.plist \
		--dart-define=GOOGLE_PLACES_API_KEY=$(GOOGLE_PLACES_API_KEY) \
		--dart-define=GOOGLE_AD_UNIT_ID_IOS=$(GOOGLE_AD_UNIT_ID_IOS) \
		--dart-define=GOOGLE_AD_UNIT_ID_ANDROID=$(GOOGLE_AD_UNIT_ID_ANDROID) \
		--dart-define=FULL_FEATURE_ENABLED=true

upload_testflight:
	xcrun altool --upload-app \
		-f "build/ios/ipa/Sweat & Beers.ipa" \
		-t ios \
		--apiKey $(APP_STORE_CONNECT_API_KEY) \
		--apiIssuer "$(APP_STORE_CONNECT_API_ISSUER)"

build_ipa_dev:
	flutter build ipa --release \
		--flavor dev \
		--export-options-plist=ios/ExportOptions-dev.plist \
		--dart-define=GOOGLE_PLACES_API_KEY=$(GOOGLE_PLACES_API_KEY) \
		--dart-define=GOOGLE_AD_UNIT_ID_IOS=$(GOOGLE_AD_UNIT_ID_IOS) \ 
		--dart-define=GOOGLE_AD_UNIT_ID_ANDROID=$(GOOGLE_AD_UNIT_ID_ANDROID)\
		--dart-define=FULL_FEATURE_ENABLED=true

build_ipa_dev_simple:
	flutter build ipa --release \
		--flavor dev \
		--export-options-plist=ios/ExportOptions-dev.plist \
		--dart-define=GOOGLE_AD_UNIT_ID_IOS=$(GOOGLE_AD_UNIT_ID_IOS) \ 
		--dart-define=GOOGLE_AD_UNIT_ID_ANDROID=$(GOOGLE_AD_UNIT_ID_ANDROID)\
		--dart-define=GOOGLE_PLACES_API_KEY=$(GOOGLE_PLACES_API_KEY)

increment_build_number:
	./scripts/increment_build_number.sh

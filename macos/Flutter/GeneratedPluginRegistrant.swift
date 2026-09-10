//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import audio_session
import file_saver
import file_selector_macos
import flutter_secure_storage_macos
import flutter_sound
import flutter_tts
import shared_preferences_foundation
import sqflite_darwin

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AudioSessionPlugin.register(with: registry.registrar(forPlugin: "AudioSessionPlugin"))
  FileSaverPlugin.register(with: registry.registrar(forPlugin: "FileSaverPlugin"))
  FileSelectorPlugin.register(with: registry.registrar(forPlugin: "FileSelectorPlugin"))
  FlutterSecureStoragePlugin.register(with: registry.registrar(forPlugin: "FlutterSecureStoragePlugin"))
  FlutterSoundPlugin.register(with: registry.registrar(forPlugin: "FlutterSoundPlugin"))
  FlutterTtsPlugin.register(with: registry.registrar(forPlugin: "FlutterTtsPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
}

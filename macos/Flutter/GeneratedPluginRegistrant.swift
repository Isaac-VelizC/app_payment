//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import file_saver
import path_provider_foundation
import share_plus
import sqflite
import wakelock_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FileSaverPlugin.register(with: registry.registrar(forPlugin: "FileSaverPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SharePlusMacosPlugin.register(with: registry.registrar(forPlugin: "SharePlusMacosPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  WakelockMacosPlugin.register(with: registry.registrar(forPlugin: "WakelockMacosPlugin"))
}

// Copyright 2026 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <XCTest/XCTest.h>

#include "connections/implementation/mediums/bluetooth_classic.h"
#include "connections/implementation/mediums/bluetooth_radio.h"
#include "connections/implementation/mediums/wifi_direct.h"
#include "connections/implementation/mediums/wifi_hotspot.h"
#include "internal/platform/mac_address.h"
#include "proto/connections_enums.pb.h"

@interface AppleUnsupportedMediumsTest : XCTestCase
@end

@implementation AppleUnsupportedMediumsTest

- (void)testBluetoothClassicIsStubbedOnApple {
  nearby::connections::BluetoothRadio radio;
  nearby::connections::BluetoothClassic bluetooth(radio);

  XCTAssertFalse(bluetooth.IsAvailable());
  XCTAssertFalse(bluetooth.IsMediumValid());
  XCTAssertFalse(bluetooth.TurnOffDiscoverability());
  XCTAssertFalse(bluetooth.StopDiscovery("service_id"));
  bluetooth.StopAllDiscovery();
  XCTAssertFalse(bluetooth.IsDiscovering("service_id"));
  XCTAssertFalse(bluetooth.IsAcceptingConnections("service_id"));
  XCTAssertFalse(bluetooth.StopAcceptingConnections("service_id"));
  XCTAssertFalse(bluetooth.GetAddress().IsSet());
  XCTAssertTrue(bluetooth.CreateBwuHandler(nullptr) == nullptr);

  auto discoverability = bluetooth.TurnOnDiscoverability("test_device");
  XCTAssertTrue(discoverability.has_value());
  XCTAssertFalse(discoverability.value());

  auto discovery = bluetooth.StartDiscovery("service_id", {});
  XCTAssertTrue(discovery.has_value());
  XCTAssertFalse(discovery.value());

  auto accepting = bluetooth.StartAcceptingConnections("service_id", {});
  XCTAssertTrue(accepting.has_value());
  XCTAssertFalse(accepting.value());
}

- (void)testWifiDirectIsStubbedOnApple {
  nearby::connections::WifiDirect wifi_direct;

  XCTAssertFalse(wifi_direct.IsGOAvailable());
  XCTAssertFalse(wifi_direct.IsGCAvailable());
  XCTAssertFalse(wifi_direct.IsGOStarted());
  XCTAssertFalse(wifi_direct.StartWifiDirect());
  XCTAssertFalse(wifi_direct.StopWifiDirect());
  XCTAssertFalse(wifi_direct.IsConnectedToGO());
  XCTAssertFalse(wifi_direct.ConnectWifiDirect({}));
  XCTAssertFalse(wifi_direct.DisconnectWifiDirect());
  XCTAssertFalse(wifi_direct.StartAcceptingConnections("service_id", {}));
  XCTAssertFalse(wifi_direct.StopAcceptingConnections("service_id"));
  XCTAssertFalse(wifi_direct.IsAcceptingConnections("service_id"));
  XCTAssertTrue(wifi_direct.GetCredentials("service_id") == nullptr);
  XCTAssertFalse(wifi_direct.SetPreferredWifiDirectAuthType(
      location::nearby::proto::connections::WIFI_DIRECT_TYPE_UNKNOWN));
  XCTAssertTrue(wifi_direct.CreateBwuHandler(nullptr) == nullptr);
}

- (void)testWifiHotspotIsStubbedOnApple {
  nearby::connections::WifiHotspot wifi_hotspot;

  XCTAssertFalse(wifi_hotspot.IsAPAvailable());
  XCTAssertFalse(wifi_hotspot.IsClientAvailable());
  XCTAssertFalse(wifi_hotspot.IsHotspotStarted());
  XCTAssertFalse(wifi_hotspot.StartWifiHotspot());
  XCTAssertFalse(wifi_hotspot.StopWifiHotspot());
  XCTAssertFalse(wifi_hotspot.IsConnectedToHotspot());
  XCTAssertFalse(wifi_hotspot.ConnectWifiHotspot({}));
  XCTAssertFalse(wifi_hotspot.DisconnectWifiHotspot());
  XCTAssertFalse(wifi_hotspot.StartAcceptingConnections("service_id", {}));
  XCTAssertFalse(wifi_hotspot.StopAcceptingConnections("service_id"));
  XCTAssertFalse(wifi_hotspot.IsAcceptingConnections("service_id"));
  XCTAssertTrue(wifi_hotspot.GetCredentials("service_id") == nullptr);
  XCTAssertTrue(wifi_hotspot.CreateBwuHandler(nullptr) == nullptr);
}

@end

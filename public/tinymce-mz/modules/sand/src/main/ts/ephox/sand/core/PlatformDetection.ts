import { Browser } from './Browser';
import { OperatingSystem } from './OperatingSystem';
import { DeviceType } from '../detect/DeviceType';
import { UaString } from '../detect/UaString';
import { PlatformInfo } from '../info/PlatformInfo';

export interface PlatformDetection {
  browser: Browser;
  os: OperatingSystem;
  deviceType: DeviceType;
}

const detect = function (userAgent: string, mediaMatch: (query: string) => boolean): PlatformDetection {
  const browsers = PlatformInfo.browsers();
  const oses = PlatformInfo.oses();

  const browser = UaString.detectBrowser(browsers, userAgent).fold(
    Browser.unknown,
    Browser.nu
  );
  const os = UaString.detectOs(oses, userAgent).fold(
    OperatingSystem.unknown,
    OperatingSystem.nu
  );
  const deviceType = DeviceType(os, browser, userAgent, mediaMatch);

  return {
    browser,
    os,
    deviceType
  };
};

export const PlatformDetection = {
  detect
};

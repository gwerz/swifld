//
//  LoadContext.swift
//  swiftld
//
//  Created by Sam Marshall on 6/27/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

import Foundation

struct LoadContext {
	var useSearchPaths: CBool;
	var useFallbackPaths: CBool;
	var userLdLibraryPath: CBool;
	var implicitRPath: CBool;
	var matchByInstallName: CBool;
	var dontLoad: CBool;
	var mustBeBundle: CBool;
	var mustBeDylib: CBool;
	var canBePIE: CBool;
	var origin: CString;
	var rpath: RPathChain;
}
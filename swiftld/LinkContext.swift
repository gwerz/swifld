//
//  LinkContext.swift
//  swiftld
//
//  Created by Sam Marshall on 6/27/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

import Foundation

struct LinkContext {
	var bindingOptions: BindingOptions;
	var argc: Int;
	var argv: UnsafePointer<CString>;
	var envp: UnsafePointer<CString>;
	var apple: UnsafePointer<CString>;
	var progname: CString;
	var progvars: ProgramVars;
	var mainExecutable: ImageLoader;
	var imageSuffix: CString;
	var rootPaths: UnsafePointer<CString>;
	var prebindingUsage: PrebindMode;
	var sharedRegionMode: SharedRegionMode;
	var dyldLoadedAtSameAddressNeededBySharedCache: CBool;
	var codeSigningEnforced: CBool;
	var mainExecutableCodeSigned: CBool;
	var preFetchDisabled: CBool;
	var prebinding: CBool;
	var bindFlat: CBool;
	var linkingMainExecutable: CBool;
	var startedInitializingMainExecutable: CBool;
	var processIsRestricted: CBool;
	var verboseOpts: CBool;
	var verboseEnv: CBool;
	var verboseMapping: CBool;
	var verboseRebase: CBool;
	var verboseBind: CBool;
	var verboseWeakBind: CBool;
	var verboseInit: CBool;
	var verboseDOF: CBool;
	var verbosePrebinding: CBool;
	var verboseCoreSymbolication: CBool;
	var verboseWarnings: CBool;
	var verboseRPaths: CBool;
	var verboseInterposing: CBool;
	var verboseCodeSignatures: CBool;
	
	func loadLibrary(name: CString, search: CBool, origin: CString, rpaths: UnsafePointer<RPathChain>) -> ImageLoader {
		var libImage: ImageLoader = ImageLoader();
		
		return libImage;
	}
	
	func terminationRecorder(image: ImageLoader) -> Void {
		
	}
	
	func flatExportFinder(name: CString, sym: UnsafePointer<Symbol>, image: ImageLoader) -> CBool {
		return true;
	}
}
//
//  dyld.swift
//  swiftld
//
//  Created by Sam Marshall on 6/27/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

import Foundation

func registerAddCallback(function: ImageCallback) -> Void {
	sAddImageCallbacks.append(function);
}

func registerRemoveCallback(function: ImageCallback) -> Void {
	sRemoveImageCallbacks.append(function);
}

func setErrorMessage(message: CString) -> Void {
	error_string = message;
}

func getErrorMessage() -> CString {
	return error_string;
}

//func halt(message: CString) -> Void {
//	setErrorMessage(message);
//	var terminationFlags: uintptr_t = 0;
//	if (!gLinkContext.startedInitializingMainExecutable) {
//		terminationFlags = 1;
//	}
//	setAllImageInfosHalf(message, terminationFlags);
//	//dyld_fatal_error(message);
//}
//
//func setAllImageInfosHalf(message: CString, flags: uintptr_t) -> Void {
//	gProcessInfo.errorMessage = message;
//	gProcessInfo.terminationFlags = flags;
//}

func findImageByMachheader(mh: MachHeaderPtr) -> ImageLoader {
	var pointer: uintptr_t = uintptr_t(mh.hashValue);
	return findMappedRange(pointer);
}

func bindLazySymbol(mh: MachHeaderPtr, lazyPointer: UnsafePointer<uintptr_t>) -> uintptr_t {
	var target: ImageLoader = findImageByMachheader(mh);
	return target.doBindLazySymbol(lazyPointer, context: gLinkContext);
}

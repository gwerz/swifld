//
//  dyld.swift
//  swiftld
//
//  Created by Sam Marshall on 6/27/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

import Foundation

func validImage(possibleImage: ImageLoader) -> CBool {
	for image: ImageLoader in sAllImages {
		if image.compare(possibleImage) == 0 {
			return true;
		}
	}
	return false;
}

func getImageCount() -> Int {
	return sAllImages.count;
}

func getIndexedImage(index: Int) -> ImageLoader {
	var image: ImageLoader = ImageLoader();
	if index < sAllImages.count {
		image = sAllImages[index];
	}
	return image;
}

func findImageByMachheader(mh: MachHeaderPtr) -> ImageLoader {
	var pointer: uintptr_t = uintptr_t(mh.hashValue);
	return findMappedRange(pointer);
}

func findImageByAddress(addr: voidPtr) -> ImageLoader {
	var pointer: uintptr_t = uintptr_t(addr.hashValue);
	return findMappedRange(pointer);
}

func findImageContainingSymbol(symbol: uintptr_t) -> ImageLoader {
	var foundImage = ImageLoader();
	for image: ImageLoader in sAllImages {
		if (image.containsSymbol(symbol)) {
			foundImage = image;
			break;
		}
	}
	return foundImage;
}

//func forEachImageDo( some closure ) -> Void {}

func findLoadedImage(stat_buf: stat) -> ImageLoader {
	var foundImage = ImageLoader();
	for image: ImageLoader in sAllImages {
		if (image.statMatch(stat_buf)) {
			foundImage = image;
			break;
		}
	}
	return foundImage;
}

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


func bindLazySymbol(mh: MachHeaderPtr, lazyPointer: UnsafePointer<uintptr_t>) -> uintptr_t {
	var target: ImageLoader = findImageByMachheader(mh);
	return target.doBindLazySymbol(lazyPointer, context: gLinkContext);
}

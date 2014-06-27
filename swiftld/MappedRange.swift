//
//  MappedRange.swift
//  swiftld
//
//  Created by Sam Marshall on 6/27/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

import Foundation

struct MappedRange {
	var image: ImageLoader;
	var start: uintptr_t;
	var end: uintptr_t;
}

func addMappedRange(image: ImageLoader, start: uintptr_t, end: uintptr_t) -> Void {
	let newRange: MappedRange = MappedRange(image: image, start: start, end: end);
	sMappedRanges.append(newRange);
}

func removeMappedRange(image: ImageLoader) -> Void {
	var index = -1;
	for range: MappedRange in sMappedRanges {
		var mappedImage = range.image as ImageLoader;
		if mappedImage.fMachOData.hashValue == image.fMachOData.hashValue {
			break;
		}
		index++;
	}
	if (index != -1) {
		sMappedRanges.removeAtIndex(index);
	}
}

func findMappedRange(target: uintptr_t) -> ImageLoader {
	var result: ImageLoader = ImageLoader();
	for range: MappedRange in sMappedRanges {
		if range.start <= target && target < range.end {
			result = range.image;
			break;
		}
	}
	return result;
}
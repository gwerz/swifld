//
//  ImageLoader.swift
//  swiftld
//
//  Created by Sam Marshall on 6/27/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

import Foundation
import MachO

class ImageLoader {
	var fState: dyld_image_state;
	var fPathOwnedByImage: CBool;
	var fMatchByInstallName: CBool;
	var fSetLeaveMapped: CBool;
	var fHideSymbols: CBool;
	var fMachOData: MachHeaderPtr;
	var fSlide: uintptr_t;;
	var fSegmentCount: CInt;
	
	var fPath: CString;
	var fRealPath: CString;
	var fDevice: dev_t;
	var fInode: ino_t;
	var fLastModified: time_t;
	var fPathHash: UInt32;
	
	var fDepth: UInt16;
	var fLoadOrder: UInt16;
	
	
	init() {
		self.fState = dyld_image_state.initialized;
		self.fPathOwnedByImage = false;
		self.fMachOData = UnsafePointer.null();
		self.fSlide = 0;
		self.fDevice = 0;
		self.fInode = 0;
		self.fLastModified = 0;
		self.fDepth = 0;
		self.fLoadOrder = 0;
		self.fPath = "";
		self.fRealPath = "";
		self.fPathHash = 0;
		self.fMatchByInstallName = false;
		self.fSetLeaveMapped = false;
		self.fHideSymbols = false;
		self.fSegmentCount = 0;
	}
	
	func setFileInfo(device: dev_t, inode: ino_t, modDate: time_t) -> Void {
		fDevice = device;
		fInode = inode;
		fLastModified = modDate;
	}
	
	func getState() -> dyld_image_state {
		return fState;
	}
	
	func setMapped(context: LinkContext) -> Void {
		fState = dyld_image_state.mapped;
		context.notifySingle(dyld_image_state.mapped, image:self);
	}
	
	func compare(image: ImageLoader) -> CInt {
		if (self.fDepth == image.fDepth) {
			if (self.fLoadOrder == image.fLoadOrder) {
				return 0
			}
			else if (self.fLoadOrder < image.fLoadOrder) {
				return -1;
			}
			else {
				return 1;
			}
		}
		else {
			if (self.fDepth < image.fDepth) {
				return -1;
			}
			else {
				return 1;
			}
		}
	}
	
	func setPath(path: CString) -> Void {
		self.fPath = path;
		self.fPathOwnedByImage = true;
		self.fPathHash = self.hash(path);
	}
	
	func setPathUnowned(path: CString) -> Void {
		self.fPath = path;
		self.fPathOwnedByImage = false;
		self.fPathHash = self.hash(path);
	}
	
	func getRealPath() -> CString {
		if (self.fRealPath != "") {
			return self.fRealPath;
		}
		else {
			return self.fPath;
		}
	}
	
	func hash(path: CString) -> UInt32 {
		var chars = path.persist() as CChar[];
		var hash: UInt32 = 0;
		for char: CChar in chars {
			hash = hash*5 + UInt32(char);
		}
		return hash;
	}
	
	func matchInstallPath() -> CBool {
		return self.fMatchByInstallName;
	}
	
	func setMatchByInstallPath(match: CBool) -> Void {
		self.fMatchByInstallName = match;
	}
	
	func statMatch(stat_buf: stat) -> CBool {
		return (self.fDevice == stat_buf.st_dev && self.fInode == stat_buf.st_ino);
	}
	
	func getShortName() -> CString {
		return self.fPath;
	}
	
	func setLeaveMapped() -> Void {
		self.fSetLeaveMapped = true;
	}
	
	func setHideExports(hide: CBool) -> Void {
		self.fHideSymbols = hide;
	}
	
	func hasHiddenExports() -> CBool {
		return self.fHideSymbols;
	}
	
	func isLinked() -> CBool {
		switch (self.fState) {
			case .mapped:
				return false;
			case .dependents_mapped:
				return false;
			case .rebased:
				return false;
			case .bound:
				return true;
			case .dependents_initialized:
				return true;
			case .initialized:
				return true;
			case .terminated:
				return true;
		}
	}
	
	func lastModified() -> time_t {
		return self.fLastModified;
	}
	
	func containsAddress(addr: uintptr_t) -> CBool {
		for index in 0..self.fSegmentCount {
//			const uint8_t* start = (const uint8_t*)segActualLoadAddress(i);
//			const uint8_t* end = (const uint8_t*)segActualEndAddress(i);
//			if ( (start <= addr) && (addr < end) && !segUnaccessible(i) )
//				return true;
		}
		return false;
	}
	
	func checkHeaderFlag(flag: CInt) -> CBool {
		var mh: mach_header = fMachOData.memory;
		var result = UInt(mh.flags) & UInt(flag);
		return (result != 0);
	}
	
	func checkFileType(type: CInt) -> CBool {
		var mh: mach_header = self.fMachOData.memory;
		var result = UInt(mh.filetype) & UInt(type);
		return (result != 0);
	}
	
	func isBundle() -> CBool {
		return self.checkFileType(MH_BUNDLE);
	}
	
	func isDylib() -> CBool {
		return self.checkFileType(MH_DYLIB);
	}
	
	func isExecutable() -> CBool {
		return self.checkFileType(MH_EXECUTE);
	}
	
	func segmentsMustSlideTogether() -> CBool {
		return true;
	}
	
	func segmentsCanSlide() -> CBool {
		return self.isDylib() || self.isBundle() || self.isPositionIndependentExecutable();
	}
	
	func isPositionIndependentExecutable() -> CBool {
		return self.checkFileType(MH_EXECUTE) && self.checkHeaderFlag(MH_PIE);
	}
	
	func usesTwoLevelNameSpace() -> CBool {
		return self.checkHeaderFlag(MH_TWOLEVEL);
	}
	
	func forceFlat() -> CBool {
		return self.checkHeaderFlag(MH_FORCE_FLAT);
	}
	
	func isPrebindable() -> CBool {
		return self.checkHeaderFlag(MH_PREBOUND);
	}
	
	func hasCoalescedExports() -> CBool {
		return self.checkHeaderFlag(MH_WEAK_DEFINES);
	}
	
	func hasReferencesToWeakSymbols() -> CBool {
		return self.checkHeaderFlag(MH_BINDS_TO_WEAK);
	}
	
	func participatesInCoalescing() -> CBool {
		return self.checkHeaderFlag(MH_WEAK_DEFINES | MH_BINDS_TO_WEAK);
	}
	
	func setSlide(slide: uintptr_t) -> Void {
		fSlide = slide;
	}
	
	func doBindLazySymbol(lazyPointer: UnsafePointer<uintptr_t>, context: LinkContext) -> uintptr_t {
		let twoLevel = self.usesTwoLevelNameSpace();
		
		return 0;
	}
}
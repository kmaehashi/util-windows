/*
	Dual/Clone Switcher for nVIDIA Display
	@version 2009/02/18
	@author Kenichi Maehashi
*/

#include <windows.h>
#include "nvapi.h"

#define ERR_OK 0
#define ERR_INVALID_ARGS 1 << 0
#define ERR_NV_INITIALIZATION_FAILED 1 << 1
#define ERR_NV_NO_DISPLAYS 1 << 2
#define ERR_NV_TOO_MANY_DISPLAYS 1 << 3
#define ERR_NV_NO_SUCH_DISPLAY 1 << 4
#define ERR_NV_INVALID_CONFIG 1 << 4
#define ERR_GENERAL 1 << 9

int displayNo = 0;
NV_TARGET_VIEW_MODE targetView = NV_VIEW_MODE_STANDARD;

int main(int argc, char* argv[]) {
	NvAPI_Status status;
	NvDisplayHandle hNvDisplays[NVAPI_MAX_PHYSICAL_GPUS * 2] = {0};
	NV_VIEW_TARGET_INFO *targetInfo;
	NV_TARGET_VIEW_MODE currentView;
	NvU32 *targetMaskCount;
	int displayCount = 0;

	// Load arguments
	if (loadArgs(argc, argv) != 0) {
		printf("Usage: %s <display#> <viewtype>\n", argv[0]);
		printf("<display#> = 1 | 2\n");
		printf("<viewtype> = standard | normal | clone | hspan | vspan | dualview | multiview\n");
		return ERR_INVALID_ARGS;
	}

	// Initialize the nVIDIA API
	status = NvAPI_Initialize();
	if (! succeed(status)) {
		NvAPI_ShortString string;
		NvAPI_GetErrorMessage(status, string);
		printf("Error: nVIDIA API Initialization failed (%s)\n", string);
		return ERR_NV_INITIALIZATION_FAILED;
	}
	
	// Enumerate all display handles
	while (succeed(status)) {
		status = NvAPI_EnumNvidiaDisplayHandle(displayCount, &hNvDisplays[displayCount]);
		switch (status) {
		case NVAPI_OK:
			displayCount++;
			break;
		case NVAPI_NVIDIA_DEVICE_NOT_FOUND:
			printf("Error: No nVIDIA displays found in the system\n");
			return ERR_NV_NO_DISPLAYS;
		default:
			break;
		}
	}

	// Check if the specified display exists
	if (displayCount < displayNo) {
		printf("Error: Display #%d not found\n", displayNo);
		return ERR_NV_NO_SUCH_DISPLAY;
	} else if (displayCount != 1 && displayCount != 2) {
		printf("Error: Unsupported number of displays (%d)\n", displayCount);
		return ERR_NV_TOO_MANY_DISPLAYS;
	}

	// Change view mode
	targetInfo = (NV_VIEW_TARGET_INFO *) malloc(sizeof(NV_VIEW_TARGET_INFO));
	targetMaskCount = (NvU32 *) malloc(sizeof(NvU32));

	if (targetInfo == NULL || targetMaskCount == NULL) {
		printf("Error: Not enough memory!\n");
		return ERR_GENERAL;
	}

	targetInfo->version = NV_VIEW_TARGET_INFO_VER;
	*targetMaskCount = -1; // no mask

	status = NvAPI_GetView(hNvDisplays[displayNo - 1], targetInfo, targetMaskCount, &currentView);
	if (! succeed(status)) {
		printf("Error: Error occured while getting view (%d)\n", status);
		return ERR_GENERAL;
	}

	if (applyInfo(targetInfo) != 0) {
		printf("Error: Unsupported configuration\n");
		return ERR_NV_INVALID_CONFIG;
	}

	status = NvAPI_SetView(hNvDisplays[displayNo - 1], targetInfo, targetView);
	if (! succeed(status)) {
		printf("Error: Error occured while setting view (%d)\n", status);
		return ERR_GENERAL;
	}

	return ERR_OK;
}

int loadArgs(int argc, char *argv[]) {
	if (argc != 3) {
		return 1;
	}

	displayNo = atoi(argv[1]);
	if (displayNo != 1 && displayNo != 2) {
		return 2;
	}

	if (strcmp(argv[2], "standard") == 0 || strcmp(argv[2], "normal") == 0) {
		targetView = NV_VIEW_MODE_STANDARD;
	} else if (strcmp(argv[2], "clone") == 0) {
		targetView = NV_VIEW_MODE_CLONE;
	} else if (strcmp(argv[2], "hspan") == 0) {
		targetView = NV_VIEW_MODE_HSPAN;
	} else if (strcmp(argv[2], "vspan") == 0) {
		targetView = NV_VIEW_MODE_VSPAN;
	} else if (strcmp(argv[2], "dualview") == 0) {
		targetView = NV_VIEW_MODE_DUALVIEW;
	} else if (strcmp(argv[2], "multiview") == 0) {
		targetView = NV_VIEW_MODE_MULTIVIEW;
	} else {
		return 3;
	}

	return 0;
}

int applyInfo(NV_VIEW_TARGET_INFO *targetInfo) {
	int retval = 0;

	switch (targetView) {
	case NV_VIEW_MODE_STANDARD:
		targetInfo->count = 1;

		targetInfo->target[0].deviceMask = getDeviceMask(0, 0, 2);

		targetInfo->target[0].sourceId = 0;
		targetInfo->target[0].bGDIPrimary = 1;
		break;

	case NV_VIEW_MODE_CLONE:
		targetInfo->count = 2;

		targetInfo->target[0].deviceMask = getDeviceMask(0, 0, 2);

		targetInfo->target[0].sourceId = 0;
		targetInfo->target[0].bGDIPrimary = 1;

		targetInfo->target[1].deviceMask = getDeviceMask(0, 0, 1);

		targetInfo->target[1].sourceId = 0;
		targetInfo->target[1].bGDIPrimary = 0;
		break;

	case NV_VIEW_MODE_DUALVIEW:
		targetInfo->count = 2;

		targetInfo->target[0].deviceMask = getDeviceMask(0, 0, 2);

		targetInfo->target[0].sourceId = 0;
		targetInfo->target[0].bGDIPrimary = 1;

		targetInfo->target[1].deviceMask = getDeviceMask(0, 0, 1);

		targetInfo->target[1].sourceId = 1;
		targetInfo->target[1].bGDIPrimary = 0;
		break;

	case NV_VIEW_MODE_HSPAN:
		// not implemented
		retval = 2;
		break;

	case NV_VIEW_MODE_VSPAN:
		// not implemented
		retval = 2;
		break;

	case NV_VIEW_MODE_MULTIVIEW:
		// not implemented
		retval = 2;
		break;

	default:
		retval = 1;
		break;
	}

	return retval;
}

int succeed(NvAPI_Status status) {
	return NVAPI_OK == status;
}

/*
	A "display device mask" is an unsigned 32 bit value that identifies
	one or more display devices: the first 8 bits each identify a CRT, the
	next 8 bits each identify a TV, and the next 8 each identify a DFP.
	For example, 0x1 refers to CRT-0, 0x3 refers to CRT-0 and CRT-1,
	0x10001 refers to CRT-0 and DFP-0, etc.
*/

// CRT の接続されたマシンの場合: getDeviceMask(n, 0, 0)
// n はデバイスの認識順を示す番号
int getDeviceMask(signed char crt, signed char tv, signed char dfp) {
	return (dfp << 16) + (tv << 8) + (crt << 0);
}

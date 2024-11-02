local function err(t)
    return utils.print_console(t, render.color(255, 25, 25))
end





local helpers = {}


function helpers.NormalizeAngle(value)
	while value > 180 do
		value = value - 360
	end

	while value < -180 do
		value = value + 360
	end

	return value
end
--@region ff things,C functions
local FFI = { 
    ffi.cdef [[
    struct pose_parameters_t
    {
        char pad[8];
        float m_flStart;
        float m_flEnd;
        float m_flState;
    };
    typedef int BOOL;
    typedef unsigned long DWORD;
    typedef unsigned int UINT;
    typedef const char* LPCSTR;
    typedef char* LPSTR;
    typedef void* HINTERNET;

    HINTERNET InternetOpenA(LPCSTR, DWORD, LPCSTR, LPCSTR, DWORD);
    HINTERNET InternetOpenUrlA(HINTERNET, LPCSTR, LPCSTR, DWORD, DWORD, DWORD);
    UINT InternetReadFile(HINTERNET, LPSTR, UINT, UINT*);
    BOOL InternetCloseHandle(HINTERNET);
       // typedefs
       typedef void VOID;
       typedef VOID* LPVOID;
       typedef uintptr_t ULONG_PTR;
       typedef uint16_t WORD;
       typedef ULONG_PTR SIZE_T;
       typedef unsigned long DWORD;
       typedef int BOOL;
       typedef ULONG_PTR DWORD_PTR;
       typedef unsigned __int64 ULONGLONG;
       typedef DWORD * LPDWORD;
       typedef ULONGLONG DWORDLONG, *PDWORDLONG;

     // structures
     typedef struct _MEMORYSTATUSEX {
       DWORD     dwLength;
       DWORD     dwMemoryLoad;
       DWORDLONG ullTotalPhys;
       DWORDLONG ullAvailPhys;
       DWORDLONG ullTotalPageFile;
       DWORDLONG ullAvailPageFile;
       DWORDLONG ullTotalVirtual;
       DWORDLONG ullAvailVirtual;
       DWORDLONG ullAvailExtendedVirtual;
     } MEMORYSTATUSEX, *LPMEMORYSTATUSEX;

     typedef struct _SYSTEM_INFO {
           union {
          DWORD dwOemId;
         struct {
               WORD wProcessorArchitecture;
               WORD wReserved;
         } DUMMYSTRUCTNAME;
       } DUMMYUNIONNAME;
           DWORD     dwPageSize;
           LPVOID    lpMinimumApplicationAddress;
           LPVOID    lpMaximumApplicationAddress;
           DWORD_PTR dwActiveProcessorMask;
           DWORD     dwNumberOfProcessors;
           DWORD     dwProcessorType;
           DWORD     dwAllocationGranularity;
           WORD      wProcessorLevel;
           WORD      wProcessorRevision;
     } SYSTEM_INFO, *LPSYSTEM_INFO;

     // fn (winapi)
     BOOL GlobalMemoryStatusEx(LPMEMORYSTATUSEX  lpBuffer);
     void GetSystemInfo(LPSYSTEM_INFO lpSystemInfo);
     typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);

     typedef struct c_animstate
     {
       char         pad0[0x60];
       void*        pEntity;
       void*        pActiveWeapon;
       void*        pLastActiveWeapon;
       float        flLastUpdateTime;
       int          iLastUpdateFrame;
       float        flLastUpdateIncrement;
       float        flEyeYaw;
       float        flEyePitch;
       float        flGoalFeetYaw;
       float        flLastFeetYaw;
       float        flMoveYaw;
       float        flLastMoveYaw;
       float        flLeanAmount;
     } CCSGOPlayerAnimationState_534535_t;

    typedef unsigned long DWORD, *PDWORD, *LPDWORD;
    typedef unsigned char byte;

    typedef struct {
        uint8_t r;
        uint8_t g;
        uint8_t b;
        uint8_t a;
    } color_struct_t;

    typedef struct {
        float x,y;
    } vec2_t;

    typedef struct {
        vec2_t m_Position;
        vec2_t m_TexCoord;
    } Vertex_t;

    typedef struct tagPOINT {
        long x;
        long y;
    } POINT;

    typedef struct
    {
        float x,y,z;
    } vec3_t;

    // HITBOXPOS STRUCTS START

    typedef struct
    {
        int id;                     //0x0000
        int version;                //0x0004
        long    checksum;               //0x0008
        char    szName[64];             //0x000C
        int length;                 //0x004C
        vec3_t  vecEyePos;              //0x0050
        vec3_t  vecIllumPos;            //0x005C
        vec3_t  vecHullMin;             //0x0068
        vec3_t  vecHullMax;             //0x0074
        vec3_t  vecBBMin;               //0x0080
        vec3_t  vecBBMax;               //0x008C
        int pad[5];
        int numhitboxsets;          //0x00AC
        int hitboxsetindex;         //0x00B0
    } studiohdr_t;

    typedef struct
    {
        void*   fnHandle;               //0x0000
        char    szName[260];            //0x0004
        int nLoadFlags;             //0x0108
        int nServerCount;           //0x010C
        int type;                   //0x0110
        int flags;                  //0x0114
        vec3_t  vecMins;                //0x0118
        vec3_t  vecMaxs;                //0x0124
        float   radius;                 //0x0130
        char    pad[28];              //0x0134
    } model_t;

    typedef struct
    {
        int     m_bone;                 // 0x0000
        int     m_group;                // 0x0004
        vec3_t  m_mins;                 // 0x0008
        vec3_t  m_maxs;                 // 0x0014
        int     m_name_id;                // 0x0020
        vec3_t  m_angle;                // 0x0024
        float   m_radius;               // 0x0030
        int        pad2[4];
    } mstudiobbox_t;

    typedef struct
    {
        int sznameindex;

        int numhitboxes;
        int hitboxindex;
    } mstudiohitboxset_t;

    typedef struct {
        float m_flMatVal[3][4];
    } matrix3x4_t;

    // HITBOXPOS STRUCTS END

    unsigned int mbstowcs(wchar_t* w, const char* s, unsigned int c);

    bool GetCursorPos(
        POINT* lpPoint
    );

    short GetAsyncKeyState(
        int vKey
    );
    int MessageBoxA(void *w, const char *txt, const char *cap, int type);
    bool CreateDirectoryA(const char* lpPathName, void* lpSecurityAttributes);
    int exit(int arg);

    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
    void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);

    int AddFontResourceA(const char* unnamedParam1);

    bool DeleteUrlCacheEntryA(const char* lpszUrlName);

    bool GetCursorPos(
        POINT* lpPoint
    );

    short GetAsyncKeyState(
        int vKey
    );

    void* GetProcAddress(void* hModule, const char* lpProcName);
    void* GetModuleHandleA(const char* lpModuleName);

    typedef void (*console_color_print)(const color_struct_t&, const char*, ...);

    typedef void (__cdecl* chat_printf)(void*, int, int, const char*, ...);

    typedef int(__fastcall* clantag_t)(const char*, const char*);

    // HITBOXPOS FUNCS START

    typedef bool(__fastcall* cbaseanim_setupbones)(matrix3x4_t *pBoneToWorldOut, int nMaxBones, int boneMask, float currentTime);

    // HITBOXPOS FUNCS END

    // PANORAMA START

    // UIEngine
    typedef void*(__thiscall* access_ui_engine_t)(void*, void); // 11
    typedef bool(__thiscall* is_valid_panel_ptr_t)(void*, void*); // 36
    typedef void*(__thiscall* get_last_target_panel_t)(void*); // 56
    typedef int (__thiscall *run_script_t)(void*, void*, char const*, char const*, int, int, bool, bool); // 113

    // IUIPanel
    typedef const char*(__thiscall* get_panel_id_t)(void*, void); // 9
    typedef void*(__thiscall* get_parent_t)(void*); // 25
    typedef void*(__thiscall* set_visible_t)(void*, bool); // 27

    // PANORAMA END
    typedef void *PVOID;
	typedef PVOID HANDLE;
	typedef unsigned long DWORD;
	typedef bool BOOL;
	typedef unsigned long ULONG_PTR;
	typedef long LONG;
	typedef char CHAR;
	typedef unsigned char BYTE;
	typedef unsigned int SIZE_T;
	typedef const void *LPCVOID;
	typedef int *FARPROC;
	typedef const char *LPCSTR;
	typedef uint16_t *UINT;

	typedef struct tagPROCESSENTRY32 {
		DWORD     dwSize;
		DWORD     cntUsage;
		DWORD     th32ProcessID;
		ULONG_PTR th32DefaultHeapID;
		DWORD     th32ModuleID;
		DWORD     cntThreads;
		DWORD     th32ParentProcessID;
		LONG      pcPriClassBase;
		DWORD     dwFlags;
		CHAR      szExeFile[260];
	} PROCESSENTRY32;

	typedef struct tagMODULEENTRY32 {
		DWORD   dwSize;
		DWORD   th32ModuleID;
		DWORD   th32ProcessID;
		DWORD   GlblcntUsage;
		DWORD   ProccntUsage;
		BYTE    *modBaseAddr;
		DWORD   modBaseSize;
		HANDLE hModule;
		char    szModule[255 + 1];
		char    szExePath[260];
	} MODULEENTRY32;

	HANDLE CreateToolhelp32Snapshot(
		DWORD dwFlags,
		DWORD th32ProcessID
	);
	
	HANDLE OpenProcess(
		DWORD dwDesiredAccess,
		BOOL  bInheritHandle,
		DWORD dwProcessId
	);
	
	BOOL Process32Next(
		HANDLE           hSnapshot,
		PROCESSENTRY32 *lppe
	);
	
	BOOL CloseHandle(
		HANDLE hObject
	);
	
	BOOL Process32First(
		HANDLE           hSnapshot,
		PROCESSENTRY32 *lppe
	);
	
	BOOL Module32Next(
		HANDLE          hSnapshot,
		MODULEENTRY32 *lpme
	);
	
	BOOL Module32First(
		HANDLE          hSnapshot,
		MODULEENTRY32 *lpme
	);
	
	BOOL ReadProcessMemory(
		HANDLE  hProcess,
		LPCVOID lpBaseAddress,
		PVOID  lpBuffer,
		SIZE_T  nSize,
		SIZE_T  *lpNumberOfBytesRead
	);
	
	BOOL WriteProcessMemory(
	  HANDLE  hProcess,
	  LPCVOID  lpBaseAddress,
	  PVOID lpBuffer,
	  SIZE_T  nSize,
	  SIZE_T  *lpNumberOfBytesWritten
	);
	
	HANDLE GetModuleHandleA(
		LPCSTR lpModuleName
	);
	
	FARPROC GetProcAddress(
		HANDLE hModule,
		LPCSTR  lpProcName
	);

	BOOL TerminateProcess(
  		HANDLE hProcess,
  		UINT   uExitCode
	);
	
	typedef void*(* Interface_t)(const char*, int*);
	typedef PVOID(__thiscall* GetEntityHandle_t)(PVOID, unsigned long);
    typedef int BOOL;
        typedef long LONG;
        typedef unsigned long HANDLE;
        typedef float*(__thiscall* bound)(void*);
        typedef HANDLE HWND;

        // color
        typedef struct {
            uint8_t r, g, b, a;
        } color_t;

        struct c_color {
            unsigned char clr[4];
        };

        // clipboard
        typedef int(__thiscall* get_clipboard_text_count)(void*);
        typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
        typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);

        // create interface
        typedef void* (*get_interface_fn)();

        typedef struct {
            get_interface_fn get;
            char* name;
            void* next;
        } interface;

        // clantag
        typedef int(__fastcall* clantag_t) (const char*, const char*);
        typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);

    typedef void*(__thiscall* get_client_entity_t)(void*, int);

    typedef struct
    {
        char pad20[24];
        uint32_t m_nSequence;
        float m_flPrevCycle;
        float m_flWeight;
        char pad20[8];
        float m_flCycle;
        void *m_pOwner;
        char pad_0038[ 4 ];
    } animation_layer_t;

    typedef struct
    {
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334
    } anim_state_t;
    typedef struct
    {
        char   pad0[0x14];             //0x0000
        bool        bProcessingMessages;    //0x0014
        bool        bShouldDelete;          //0x0015
        char   pad1[0x2];              //0x0016
        int         iOutSequenceNr;         //0x0018 last send outgoing sequence number
        int         iInSequenceNr;          //0x001C last received incoming sequence number
        int         iOutSequenceNrAck;      //0x0020 last received acknowledge outgoing sequence number
        int         iOutReliableState;      //0x0024 state of outgoing reliable data (0/1) flip flop used for loss detection
        int         iInReliableState;       //0x0028 state of incoming reliable data
        int         iChokedPackets;         //0x002C number of choked packets
    } INetChannel; // Size: 0x0444

    typedef bool(__thiscall* file_exists_t)(void* this, const char* pFileName, const char* pPathID);
    typedef int BOOL;
    typedef long LONG;
    typedef unsigned long HWND;
    typedef struct{
        LONG x, y;
    }POINT, *LPPOINT;
    typedef unsigned long DWORD, *PDWORD, *LPDWORD;

    typedef struct {
        DWORD  nLength;
        void* lpSecurityDescriptor;
        BOOL   bInheritHandle;
    } SECURITY_ATTRIBUTES, *PSECURITY_ATTRIBUTES, *LPSECURITY_ATTRIBUTES;

    short GetAsyncKeyState(int vKey);
    typedef struct mask {
        char m_pDriverName[512];
        unsigned int m_VendorID;
        unsigned int m_DeviceID;
        unsigned int m_SubSysID;
        unsigned int m_Revision;
        int m_nDXSupportLevel;
        int m_nMinDXSupportLevel;
        int m_nMaxDXSupportLevel;
        unsigned int m_nDriverVersionHigh;
        unsigned int m_nDriverVersionLow;
        int64_t pad_0;
        union {
            int xuid;
            struct {
                int xuidlow;
                int xuidhigh;
            };
        };
        char name[128];
        int userid;
        char guid[33];
        unsigned int friendsid;
        char friendsname[128];
        bool fakeplayer;
        bool ishltv;
        unsigned int customfiles[4];
        unsigned char filesdownloaded;
    };
    typedef int(__thiscall* get_current_adapter_fn)(void*);
    typedef void(__thiscall* get_adapters_info_fn)(void*, int adapter, struct mask& info);
    typedef bool(__thiscall* file_exists_t)(void* this, const char* pFileName, const char* pPathID);
    typedef long(__thiscall* get_file_time_t)(void* this, const char* pFileName, const char* pPathID);
    ]],
    VMT = function(self)
        self.VMT = {}

        self.VMT.bind = function(vmt_table, func, index)
            local result = ffi.cast(ffi.typeof(func), vmt_table[0][index])

            return function(...)
                return result(vmt_table, ...)
            end
        end
        self.VMT.table = function(module_name, interface_name, index, typestring)
            local addr = utils.find_interface(module_name, interface_name);
            assert(addr, string.format("%s::%s is invalid interface", module_name, interface_name));

            local ctype = ffi.typeof(typestring);

            local vtable = ffi.cast("void***", addr);
            local vfunc = ffi.cast(ctype, vtable[0][index]);

            return function(...)
                return vfunc(vtable, ...);
            end
        end
    end,
    render = function(self)
        self.interfaces                         = {
            newptr = ffi.typeof('int[1]'),
            charbuffer = ffi.typeof('char[?]'),
            new_widebuffer = ffi.typeof('wchar_t[?]'),
        }

        self.RawLocalize                        = utils.find_interface('localize.dll', 'Localize_001')
        self.Localize                           = ffi.cast(ffi.typeof('void***'), self.RawLocalize)
        self.FindSafe                           = self.VMT.bind(self.Localize,
            'wchar_t*(__thiscall*)(void*, const char*)',
            12)
        self.ConvertAnsiToUnicode               = self.VMT.bind(self.Localize,
            'int(__thiscall*)(void*, const char*, wchar_t*, int)', 15)
        self.ConvertUnicodeToAnsi               = self.VMT.bind(self.Localize,
            'int(__thiscall*)(void*, wchar_t*, char*, int)', 16)

        -- GUI Surface
        self.VGUI_Surface031                    = utils.find_interface('vguimatsurface.dll', 'VGUI_Surface031')
        self.g_VGuiSurface                      = ffi.cast(ffi.typeof('void***'), self.VGUI_Surface031)

        self.native_Surface                     = {}
        self.native_Surface.DrawSetColor        = self.VMT.bind(self.g_VGuiSurface,
            "void(__thiscall*)(void*, int, int, int, int)", 15)
        self.native_Surface.FontCreate          = self.VMT.bind(self.g_VGuiSurface, 'unsigned long(__thiscall*)(void*)',
            71)
        self.native_Surface.SetFontGlyphSet     = self.VMT.bind(self.g_VGuiSurface,
            'void(__thiscall*)(void*, unsigned long, const char*, int, int, int, int, unsigned long, int, int)', 72)
        self.native_Surface.GetTextSize         = self.VMT.bind(self.g_VGuiSurface,
            'void(__thiscall*)(void*, unsigned long, const wchar_t*, int&, int&)', 79)
        self.native_Surface.DrawSetTextColor    = self.VMT.bind(self.g_VGuiSurface,
            'void(__thiscall*)(void*, int, int, int, int)', 25)
        self.native_Surface.DrawSetTextFont     = self.VMT.bind(self.g_VGuiSurface,
            'void(__thiscall*)(void*, unsigned long)', 23)
        self.native_Surface.DrawSetTextPos      = self.VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, int)',
            26)
        self.native_Surface.DrawPrintText       = self.VMT.bind(self.g_VGuiSurface,
            'void(__thiscall*)(void*, const wchar_t*, int, int)', 28)
        self.native_Surface.DrawTexturedPolygon = self.VMT.bind(self.g_VGuiSurface,
            "void(__thiscall*)(void*, int, Vertex_t*, bool)", 106)
        self.native_Surface.DrawFilledRectFade  = self.VMT.bind(self.g_VGuiSurface,
            "void(__thiscall*)(void*, int, int, int, int, unsigned int, unsigned int, bool)", 123)
        self.native_Surface.DrawFilledRect      = self.VMT.bind(self.g_VGuiSurface,
            'void(__thiscall*)(void*, int, int, int, int)', 16)
        self.native_Surface.DrawOutlinedRect    = self.VMT.bind(self.g_VGuiSurface,
            'void(__thiscall*)(void*, int, int, int, int)', 18)
        self.native_Surface.DrawLine            = self.VMT.bind(self.g_VGuiSurface,
            'void(__thiscall*)(void*, int, int, int, int)', 19)
        self.native_Surface.DrawOutlinedCircle  = self.VMT.bind(self.g_VGuiSurface,
            'void(__thiscall*)(void*, int, int, int, int)', 103)
        self.native_Surface.polygon             = self.VMT.table("vguimatsurface.dll", "VGUI_Surface031", 20,
            "void(__thiscall*)(void*, int*, int*, int)")
        self.EFontFlags                         = ffi.typeof([[
            enum {
                NONE,
                ITALIC		 = 0x001,
                UNDERLINE	 = 0x002,
                STRIKEOUT	 = 0x004,
                SYMBOL		 = 0x008,
                ANTIALIAS	 = 0x010,
                GAUSSIANBLUR = 0x020,
                ROTARY		 = 0x040,
                DROPSHADOW	 = 0x080,
                ADDITIVE	 = 0x100,
                OUTLINE		 = 0x200,
                CUSTOM		 = 0x400,
                BOLD = 0x800
            }
        ]])

        self.PrintText                          = function(text, localized)
            local size = 1024.0
            if localized then
                local char_buffer = self.interfaces.charbuffer(size)
                self.ConvertUnicodeToAnsi(text, char_buffer, size)

                return self.native_Surface.DrawPrintText(text, #ffi.string(char_buffer), 0)
            else
                local wide_buffer = self.interfaces.new_widebuffer(size)

                self.ConvertAnsiToUnicode(text, wide_buffer, size)
                return self.native_Surface.DrawPrintText(wide_buffer, #text, 0)
            end
        end

        self.font_cache                         = {}
    end,
    Update = {
        AnimStateOffset = 0x9960,
    },
    setup = function(self)
        -- Get Entity

        self:VMT()
        self:render()
        -- Get Entity
        self.VGUI_System_dll = utils.find_interface('vgui2.dll', 'VGUI_System010')
        self.VGUI_System = ffi.cast(ffi.typeof('void***'), self.VGUI_System_dll)
        self.get_clipboard_text_count = ffi.cast('get_clipboard_text_count', self.VGUI_System[0][7])
        self.get_clipboard_text = ffi.cast('get_clipboard_text', self.VGUI_System[0][11])
        self.set_clipboard_text = ffi.cast('set_clipboard_text', self.VGUI_System[0][9])

        local fn_change_clantag = utils.find_pattern('engine.dll', '53 56 57 8B DA 8B F9 FF 15')
        self.set_clantag = ffi.cast('clantag_t', fn_change_clantag)
        self.ClientEntityList = ffi.cast("void***", utils.find_interface("client.dll", "VClientEntityList003"))
        self.GetClientEntity = ffi.cast("GetClientEntity_4242425_t", self.ClientEntityList[0][3])

        self.GetEntityAddress = function(ent_index)
            return ffi.cast('GetClientEntity_4242425_t', self.ClientEntityList[0][3])(self.ClientEntityList, ent_index)
        end

        self.set_sky = ffi.cast(ffi.typeof('void(__fastcall*)(const char*)'),
            utils.find_pattern("engine.dll", "55 8B EC 81 EC ? ? ? ? 56 57 8B F9 C7 45"))


        self.GetAnimationState = function(entity)
            if not entity then return end
            return ffi.cast('struct c_animstate**',
                self.GetEntityAddress(entity:get_index()) + self.Update.AnimStateOffset)[0]
        end
    end
}
FFI:setup()
--@endregion ff things,C functions
--@region Entity
local entity = {}
do
    entity.local_player = function()
        local lp = engine.get_local_player()
        local local_player = entities.get_entity(engine.get_local_player())
        local valid
        do
            if engine.is_in_game() then
                if local_player:is_alive() and local_player:is_player() then
                    valid = true
                else
                    valid = false
                end
            else
                valid = false
            end
        end
        local entity_index
        do
            if valid then
                entity_index = local_player:get_index()
            else
                entity_index = 0
            end
        end
        local function prop(array, ...)
            return local_player:get_prop(array, ...)
        end
        return {
            index = lp,
            entity_index = entity_index,
            player = local_player,
            valid = valid,
            prop = prop,
        }
    end
end
--@endregion Entity



--@region: Libs
local vmt = require('vmt_hooks')
local tools = require("tools")
local config = require("config")
local renderer = require("render")
--@endregion: Libs







--@region: Basic Defs
local ui = {}
local misc_ui = {}
local visuals_ui = {}
local aa_pizdec = {}
local misc_func = {}
local visuals_func = {}
local callbacks = {}
local antiaim_ui = {}
local builder_ui = {}
local aimbot_func = {}
local aimbot_ui = {}
local info = {}
local logs = {}
local configs_ui = {}
local Configs_sys = {}
Find = gui.get_config_item
slider = gui.add_slider
switch = gui.add_checkbox
Show = gui.set_visible
combo = gui.add_combo
list = gui.add_listbox
selectable = gui.add_multi_combo
color_picker = gui.add_colorpicker


--@endregion: Basic Defs
--add getting data from database by http request
--@region: Refereces
local atlantic = fetchStats and fetchStats() or {
    discord = "",
    username = "Atlantic",
    build = "Alpha"
}
refereces = {
    AntiAim = Find("Rage>Anti-Aim>Angles>Anti-aim"),
    Pitch = Find("Rage>Anti-Aim>Angles>Pitch"),
    Yaw_selection = Find("Rage>Anti-Aim>Angles>Yaw"),
    Yaw_Chck = Find("Rage>Anti-Aim>Angles>Yaw add"),
    Yaw = Find("Rage>Anti-Aim>Angles>Add"),
    Freestand = Find("Rage>Anti-Aim>Angles>Freestand"),
    At_fov_target = Find("Rage>Anti-Aim>Angles>At fov target"),
    jitterrange = Find("rage>anti-aim>angles>jitter range"),
    jitter = Find("rage>anti-aim>angles>jitter"),
    Desync_Chck = Find("rage>anti-aim>desync>fake"),
    fakeamount = Find("rage>anti-aim>desync>fake amount"),
    mindmg = Find("rage>aimbot>ssg08>scout>override"),
    compensate = Find("rage>anti-aim>desync>compensate angle"),
    fsfake = Find("rage>anti-aim>desync>freestand fake"),
    inverter = Find("rage>anti-aim>desync>Flip fake with jitter"),
    slide = Find("misc>movement>slide"),
    jitterRandom = Find("rage>anti-aim>angles>Random"),
    fakelaglimit = Find("rage>anti-aim>fakelag>limit"),
    fakelagmode = Find("rage>anti-aim>fakelag>Mode"),
    dormant_aimbot = Find("rage>aimbot>aimbot>target dormant"),
    AP = Find("Misc>Movement>Peek Assist"),
    FD = Find("Misc>Movement>Fake Duck"),
    DT = Find("Rage>aimbot>aimbot>double tap"),
    OSAA = Find("Rage>aimbot>aimbot>Hide Shot"),
    Manual_ovr = Find("rage>anti-aim>angles>Antiaim override"),
    Manual_back = Find("rage>anti-aim>angles>Back"),
    Manual_left = Find("rage>anti-aim>angles>Left"),
    Manual_right = Find("rage>anti-aim>angles>Right"),
    Legs = Find("rage>anti-aim>desync>leg slide")
}
--@endregion: Refereces
--@region: Download
local function proc_bind(module_name, function_name, typedef)
local get_dll = proc_bind("kernel32.dll", "LoadLibraryA", "intptr_t(__stdcall*)(const char*)")
local urlmon = get_dll("urlmon.dll")
local wininet = get_dll('WinInet')
local Download = function(from, to)
    wininet.DeleteUrlCacheEntryA(from)
    urlmon.URLDownloadToFileA(nil, from, to, 0,0)
end
normal = fs.create_dir('fatality/atlantic')
path = fs.create_dir('fatality/atlantic/fonts')

local to_download = {
    { link = 'https://files.catbox.moe/wkp4ub.ttf', path = "Atlantic/fonts/Verdana Bold.ttf" },
    { link = 'https://files.catbox.moe/rfw8ir.ttf', path = 'Atlantic/fonts/Bold.ttf'},
    { link = 'https://files.catbox.moe/29eybb.otf', path = 'Atlantic/fonts/Bold2.otf'},
    { link = 'https://files.catbox.moe/gsrsqb.png', path = 'Atlantic/fonts/logo.png'},
}
for i, v in pairs(to_download) do
    if not fs.exists(v.path) then
        Download(v.link,v.path, 0, 0)
        print("Downloaded: " .. v.path)
    end
end
end
--@endregion: Download

--@region: local_player
local function vtable_thunk(_type, index)
    local ffitype = ffi.typeof(_type)
    return function(class, ...)
        local this = ffi.cast("void***", class)
        return ffi.cast(ffitype, this[0][index])(this, ...)
    end
end

local VClientEntityList = utils.find_interface("client.dll", "VClientEntityList003")
local GetClientEntityFN = vtable_thunk("void*(__thiscall*)(void*, int)", 3)

local animation_breakers = {}
animation_breakers.collected_cache = {}

local studio_hdr_offset = 0x2950
local allanimstate_offset = 0x9960
local landing_offset = 0x109


local pose_parameter_pattern = "55 8B EC 8B 45 08 57 8B F9 8B 4F 04 85 C9 75 15"
local get_pose_parameters = ffi.cast("struct pose_parameters_t*(__thiscall* )(void*, int)",utils.find_pattern("client.dll", pose_parameter_pattern))

local function call(f)
    --local s, e = pcall(f)
    --if not s then err(e.. "\n") end
end
function SetPose(self_pointer, layer, start_value, end_value)
    local new_player_pointer = ffi.cast("unsigned int", self_pointer)
    local NULL = 0x0
    if new_player_pointer == NULL then
        return false
    end
    local studio_hdr = ffi.cast("void**", new_player_pointer + studio_hdr_offset)[0]

    if not studio_hdr or studio_hdr == NULL then
        return false
    end

    local pose_parameters = get_pose_parameters(studio_hdr, layer)
    if not pose_parameters or pose_parameters == NULL then
        return false
    end

    if animation_breakers.collected_cache[layer] == nil then
        animation_breakers.collected_cache[layer] = {}

        animation_breakers.collected_cache[layer].m_flStart = pose_parameters.m_flStart
        animation_breakers.collected_cache[layer].m_flEnd = pose_parameters.m_flEnd
        animation_breakers.collected_cache[layer].m_flState = pose_parameters.m_flState

        animation_breakers.collected_cache[layer].is_applied = false
        return true
    end

    if start_value ~= nil and not animation_breakers.collected_cache[layer].is_applied then
        pose_parameters.m_flStart = start_value
        pose_parameters.m_flEnd = end_value

        pose_parameters.m_flState = (pose_parameters.m_flStart + pose_parameters.m_flEnd) / 2
        animation_breakers.collected_cache[layer].is_applied = true

        return true
    end
    if animation_breakers.collected_cache[layer].is_applied then
        pose_parameters.m_flStart = animation_breakers.collected_cache[layer].m_flStart
        pose_parameters.m_flEnd = animation_breakers.collected_cache[layer].m_flEnd
        pose_parameters.m_flState = animation_breakers.collected_cache[layer].m_flState

        animation_breakers.collected_cache[layer].is_applied = false
        return true
    end
    return false
end
--@endregion: local_player



aa_pizdec.conditions = {"Share", "Stand", "Run", "Crouch","Crab+Move" ,"Air", "Air+C","Slow Walk","Fake Duck","Freestand","Fake Lag"}

local build = atlantic.build
local info = 
{
    "Welcome to Atlantic.oce",
    "Best Lua ever done:",
    " 1. Best Aimbot System",
    " 2. Unhittable Anti-Aim System",
    " 3. Beautiful Visuals",
    " 4. Useful Miscellaneous",
    "All this in Clean and Simple UI",
    "Developer: Tabihvh",
    "Build: ".. build
}
info.informations = list("Informations", "Rage>Anti-Aim>Angles",#info,false,info)
--@region: Menu
local Tabs = {
    Main = combo("Atlantic.oce", "Rage>Anti-Aim>Angles", {"Main","Rage","Other"}),
    Other = combo("Other", "Rage>Anti-Aim>Angles", {"Features","Configs"}),
    Rage = combo("Rage","Rage>Anti-Aim>Angles",{"Aimbot","Anti-Aimbot"}),
}
info.dpi_scale_table = {"0.5", "0.75", "1.0", "1.5", "2.0", "2.5", "3.0"}
info.dpi_scale = combo("DPI Scale", "Rage>Anti-Aim>Angles", info.dpi_scale_table)

local fonts = {}
local x, y = render.get_screen_size()
local previous_dpi_scale = nil

-- Function to update font based on DPI scale
local function update_font()
    local selected_dpi_scale = tonumber(info.dpi_scale_table[info.dpi_scale:get_int() + 1]) or 1.0
    if selected_dpi_scale ~= previous_dpi_scale then
        fonts.verdana = render.create_font("verdana.ttf", 20 * selected_dpi_scale)
        previous_dpi_scale = selected_dpi_scale
    end
end





aimbot_ui.improve_dt = switch("Improve Double Tap", "Rage>Anti-Aim>Angles")
aimbot_ui.better_dt_slider = slider("Double Tap Speed", "Rage>Anti-Aim>Angles", 1, 20, 1)
misc_ui.kys_switch = switch("Killsay", "Rage>Anti-Aim>Angles")
misc_ui.kys = combo("Type","Rage>Anti-Aim>Angles", {"advertisement", "Medusa.uno", "Toxic", "1"})
misc_ui.ct = combo("Clantags","Rage>Anti-Aim>Angles", {"OFF", "Atlantic.oce", "Medusa.uno"})
visuals_ui.line = list("                            Visuals             ", "Rage>Anti-Aim>Desync",1,false,{"--------------------------------------------------"})
visuals_ui.crosshair_ind = {}
visuals_ui.watermark,visuals_ui.side_ind,visuals_ui.crosshair_ind.switch = selectable("Widgets", "Rage>Anti-Aim>Desync", {"Watermark","Side Indicators","Crosshair Indicators"})
visuals_ui.crosshair_ind.y = slider("Hight", "Rage>Anti-Aim>Desync", 0, 100,1)
visuals_ui.watermark_color = color_picker("Rage>Anti-Aim>Desync>Widgets",false)
visuals_ui.watermark_alpha = slider("Background Alpha", "Rage>Anti-Aim>Desync", 0, 255, 100)





visuals_ui.logs_type = {}
visuals_ui.logs_type.console,visuals_ui.logs_type.event,visuals_ui.logs_type.screen = gui.add_multi_combo("Logs Type", "Rage>Anti-Aim>Desync", {"Console","Event","Screen"})
visuals_ui.logs = combo("Logs Style", "Rage>Anti-Aim>Desync", {"Off","Simple","Modern"})

misc_ui.super_toss = combo("Super Toss", "Rage>Anti-Aim>Angles", {"off", "Smart", "Semi", "Full"})

ui.new_menu = function()
    Show("Rage>Anti-Aim>Angles>Atlantic.oce", true)


    Show("Rage>Anti-Aim>Angles>DPI Scale", Tabs.Main:get_int() == 0)
    Show("Rage>Anti-Aim>Angles>Rage", Tabs.Main:get_int() == 1)
    Show("Rage>Anti-Aim>Angles>Improve Double Tap", Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 0)
    Show("Rage>Anti-Aim>Angles>Double Tap Speed", Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 0 and aimbot_ui.improve_dt:get_bool())
    Show("Rage>Anti-Aim>Angles>Killsay", Tabs.Main:get_int() == 2 and Tabs.Other:get_int() == 0)
    Show("Rage>Anti-Aim>Angles>Clantags", Tabs.Main:get_int() == 2 and Tabs.Other:get_int() == 0)
    Show("Rage>Anti-Aim>Angles>Type", Tabs.Main:get_int() == 2 and Tabs.Other:get_int() == 0 and misc_ui.kys_switch:get_bool())
    Show("Rage>Anti-Aim>Angles>Other", Tabs.Main:get_int() == 2)
    Show("Rage>Anti-Aim>Desync>                            Visuals             ", Tabs.Main:get_int() == 2 and Tabs.Other:get_int() == 0)
    Show("Rage>Anti-Aim>Desync>Hight", Tabs.Main:get_int() == 2 and Tabs.Other:get_int() == 0 and visuals_ui.crosshair_ind.switch:get_bool())
    Show("Rage>Anti-Aim>Desync>Background Alpha", Tabs.Main:get_int() == 2 and Tabs.Other:get_int() == 0 and visuals_ui.watermark:get_bool())
    Show("Rage>Anti-Aim>Desync>Logs Type", Tabs.Main:get_int() == 2 and Tabs.Other:get_int() == 0)
    Show("Rage>Anti-Aim>Desync>Logs Style", Tabs.Main:get_int() == 2 and Tabs.Other:get_int() == 0)
    Show("Rage>Anti-Aim>Angles>Super Toss", Tabs.Main:get_int() == 2 and Tabs.Other:get_int() == 0)

    Show("Rage>Anti-Aim>Desync>Widgets", Tabs.Main:get_int() == 2 and Tabs.Other:get_int() == 0)

end

antiaim_ui.AntiAim_type = combo("Anti-Aim Type","Rage>Anti-Aim>Angles",{"Fatality","Atlantic"})
antiaim_ui.state = combo("Current State", "Rage>Anti-Aim>Angles", aa_pizdec.conditions)
antiaim_ui.Other = list("Other", "Rage>Anti-Aim>Desync",4,false,{"General","Manuals","Breakers","Exploits"})
antiaim_ui.freestand = switch("Freestand","Rage>Anti-Aim>Desync")
gui.add_keybind("Rage>Anti-Aim>Desync>Freestand")
antiaim_ui.at_target = switch("At Target", "Rage>Anti-Aim>Desync")
antiaim_ui.manual = {}
antiaim_ui.manual.left = switch("Force Left", "Rage>Anti-Aim>Desync")
gui.add_keybind("Rage>Anti-Aim>Desync>Force Left")
antiaim_ui.manual.right = switch("Force Right", "Rage>Anti-Aim>Desync")
gui.add_keybind("Rage>Anti-Aim>Desync>Force Right")
antiaim_ui.manual.back = switch("Force Back", "Rage>Anti-Aim>Desync")
gui.add_keybind("Rage>Anti-Aim>Desync>Force Back")
antiaim_ui.breakers = {}
antiaim_ui.breakers.ground = combo("Ground Breakers","Rage>Anti-Aim>Desync", {"Jitter Legs","MoonWalk"})
antiaim_ui.breakers.air = combo("Air Breakers","Rage>Anti-Aim>Desync", {"Static Air","Jitter Air"})
antiaim_ui.breakers.other = {}
antiaim_ui.breakers.other.meme = {}
antiaim_ui.breakers.other.lower_body_yaw,antiaim_ui.breakers.other.meme.check,antiaim_ui.breakers.other.pitch_on_land = selectable("Other Breakers","Rage>Anti-Aim>Desync", {"Lower Body Yaw","Meme Breakers","0 Pitch on Land"})
antiaim_ui.breakers.other.meme.fd = selectable("Meme Breakers","Rage>Anti-Aim>Desync", {"Fake Duck"})
--@region: Anti-Aim Menu
for i=1,#aa_pizdec.conditions do
    builder_ui[i] = {}
    builder_ui[i].override = switch("Enable \v"..aa_pizdec.conditions[i].."\r State","Rage>Anti-Aim>Angles")
    builder_ui[i].pitch = combo(string.format("%s Pitch",aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", {"None","Down","Up","Zero"})
    builder_ui[i].yaw_base = combo(string.format("%s Yaw Base",aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles",{"None","Backwards","Zero","Random"})
    builder_ui[i].yaw = combo(string.format("%s Yaw",aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles",{"Static","L&R"})
    builder_ui[i].yaw_L = slider(string.format("%s Yaw Left",aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles",0,180,0)
    builder_ui[i].yaw_R = slider(string.format("%s Yaw Right",aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles",0,180,0)
    builder_ui[i].yaw_delay = slider(string.format("%s Yaw Delay",aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles",3,16,0)
    builder_ui[i].yaw_add = slider(string.format("%s Yaw Offset",aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles",-180,180,0)
    builder_ui[i].Jitter_type = combo(string.format("%s Jitter Type",aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", {"Off","Classic","Random"})
    builder_ui[i].jitter_range = slider(string.format("%s Jitter Offset", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", -180,180,0)
    builder_ui[i].Desync_type = combo(string.format("%s Desync Type", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", {"Off","Static","Sway","Random"})
    builder_ui[i].Random_type = combo(string.format("%s Random Type", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", {"Natural","Min&Max"})
    builder_ui[i].Random_amount_min = slider(string.format("%s Random Min Amount", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", 0,100,0)
    builder_ui[i].Random_amount_max = slider(string.format("%s Random Max Amount", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", 0,100,0)
    builder_ui[i].Desync_amount = slider(string.format("%s Desync Amount", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", -100,100,0)
    builder_ui[i].Compansate_angle_type = combo(string.format("%s Compansate Angle Type", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", {"Off","Static","Random"})
    builder_ui[i].comp_Random_type = combo(string.format("%s Compansate Angle Random Type", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", {"Natural","Min&Max"})
    builder_ui[i].comp_Random_amount_min = slider(string.format("%s Compansate Angle Random Min Amount", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", 0,100,0)
    builder_ui[i].comp_Random_amount_max = slider(string.format("%s Compansate Angle Random Max Amount", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", 0,100,0)
    builder_ui[i].Compansate_angle_amount = slider(string.format("%s Compansate Angle Amount", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", 0,100,0)
    builder_ui[i].Freestand_fake = combo(string.format("%s Freestand Fake", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", {"None","Normal","Opposite"})
    builder_ui[i].separator = list(string.format("%s Defensive", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles",1,false,{"--------------------------------------------------"})
    builder_ui[i].Defensive_Switch = switch(string.format("%s Enable Defensive", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles")
    builder_ui[i].Defensive_delay = slider(string.format("%s Defensive Delay", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", 1, 16, 1)
    builder_ui[i].Defensive_pitch = combo(string.format("%s Defensive Pitch", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", {"Zero","Semi Up","Semi Down","Switch","Random","Custom"})
    builder_ui[i].Defensive_Switch1 = slider(string.format("%s Defensive Pitch Offset 1", aa_pizdec.conditions[i]),"Rage>Anti-Aim>Angles", -89, 89, 0)
    builder_ui[i].Defensive_Switch2 = slider(string.format("%s Defensive Pitch Offset 2", aa_pizdec.conditions[i]),"Rage>Anti-Aim>Angles", -89, 89, 0)
    builder_ui[i].Defensive_Random_type = combo(string.format("%s Defensive Random Type", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", {"Natural","Min&Max"})
    builder_ui[i].Defensive_random_amount_min = slider(string.format("%s Defensive Random Min Amount", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", 0,100,0)
    builder_ui[i].Defensive_random_amount_max = slider(string.format("%s Defensive Random Max Amount", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", 0,100,0)
    builder_ui[i].Defensive_custom = slider(string.format("%s Defensive Custom Pitch", aa_pizdec.conditions[i]),"Rage>Anti-Aim>Angles", -89, 89, 0)
    builder_ui[i].Defensive_yaw = combo(string.format("%s Defensive Yaw", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", {"None","Side-Ways","Switch","Random","Custom"})
    builder_ui[i].Defensive_yaw_offset1 = slider(string.format("%s Defensive Yaw Offset 1", aa_pizdec.conditions[i]),"Rage>Anti-Aim>Angles", 0, 180, 0)
    builder_ui[i].Defensive_yaw_offset2 = slider(string.format("%s Defensive Yaw Offset 2", aa_pizdec.conditions[i]),"Rage>Anti-Aim>Angles", 0, 180, 0)
    builder_ui[i].Defensive_random_type_yaw = combo(string.format("%s Defensive Random Type Yaw", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", {"Natural","Min&Max"})
    builder_ui[i].Defensive_random_amount_yaw_min = slider(string.format("%s Defensive Random Min Amount Yaw", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", 0,100,0)
    builder_ui[i].Defensive_random_amount_yaw_max = slider(string.format("%s Defensive Random Max Amount Yaw", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Angles", 0,100,0)
    builder_ui[i].Defensive_custom_yaw = slider(string.format("%s Defensive Custom Yaw", aa_pizdec.conditions[i]),"Rage>Anti-Aim>Angles", 0, 180, 0)

    builder_ui[i].Roll_switch = switch(string.format("%s Roll", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Desync")
    builder_ui[i].Roll_type = combo(string.format("%s Roll Type", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Desync", {"Static","Random"})
    builder_ui[i].Roll_amount = slider(string.format("%s Roll Amount", aa_pizdec.conditions[i]), "Rage>Anti-Aim>Desync", -180, 180, 0)
end

ui.AntiAim_menu = function()                     
    builder_ui[1].override:set_bool(true)
    local state = antiaim_ui.state:get_int() + 1
    for i=1,#aa_pizdec.conditions do
        local cond_depend = {antiaim_ui.state, aa_pizdec.conditions[i]}
        local state_enabled = builder_ui[i].override:get_bool()
        Show("Rage>Anti-Aim>Angles>Current State", Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1)
        Show("Rage>Anti-Aim>Angles>Enable \v"..aa_pizdec.conditions[i].."\r State",Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and i ~= 1 and state == i)
        Show(string.format("Rage>Anti-Aim>Angles>%s Pitch",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i)
        Show(string.format("Rage>Anti-Aim>Angles>%s Yaw Base",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i)
        Show(string.format("Rage>Anti-Aim>Angles>%s Yaw",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i)
        Show(string.format("Rage>Anti-Aim>Angles>%s Yaw Offset",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].yaw:get_int() == 0)
        Show(string.format("Rage>Anti-Aim>Angles>%s Yaw Left",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].yaw:get_int() == 1)
        Show(string.format("Rage>Anti-Aim>Angles>%s Yaw Right",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].yaw:get_int() == 1)
        Show(string.format("Rage>Anti-Aim>Angles>%s Yaw Delay",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].yaw:get_int() == 1)
        Show(string.format("Rage>Anti-Aim>Angles>%s Jitter Type",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i)
        Show(string.format("Rage>Anti-Aim>Angles>%s Jitter Offset",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Jitter_type:get_int() ~= 0)
        Show(string.format("Rage>Anti-Aim>Angles>%s Desync Type",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i)
        Show(string.format("Rage>Anti-Aim>Angles>%s Random Type",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Desync_type:get_int() == 3)
        Show(string.format("Rage>Anti-Aim>Angles>%s Random Min Amount",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Desync_type:get_int() == 3 and builder_ui[i].Random_type:get_int() == 1)
        Show(string.format("Rage>Anti-Aim>Angles>%s Random Max Amount",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Desync_type:get_int() == 3 and builder_ui[i].Random_type:get_int() == 1)

        Show(string.format("Rage>Anti-Aim>Angles>%s Desync Amount",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Desync_type:get_int() ~= 0 and builder_ui[i].Desync_type:get_int() ~= 3)
        Show(string.format("Rage>Anti-Aim>Angles>%s Compansate Angle Type",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i)
        Show(string.format("Rage>Anti-Aim>Angles>%s Compansate Angle Random Type",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Compansate_angle_type:get_int() == 2)
        Show(string.format("Rage>Anti-Aim>Angles>%s Compansate Angle Random Min Amount",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Compansate_angle_type:get_int() == 2 and builder_ui[i].comp_Random_type:get_int() == 1)
        Show(string.format("Rage>Anti-Aim>Angles>%s Compansate Angle Random Max Amount",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Compansate_angle_type:get_int() == 2 and builder_ui[i].comp_Random_type:get_int() == 1)
        Show(string.format("Rage>Anti-Aim>Angles>%s Compansate Angle Amount",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Compansate_angle_type:get_int() == 1 and builder_ui[i].comp_Random_type:get_int() == 0)
        Show(string.format("Rage>Anti-Aim>Angles>%s Freestand Fake",aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i)



        Show(string.format("Rage>Anti-Aim>Angles>%s Defensive", aa_pizdec.conditions[i]),Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i)
        Show(string.format("Rage>Anti-Aim>Angles>%s Enable Defensive", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i)
        Show(string.format("Rage>Anti-Aim>Angles>%s Defensive Delay", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Defensive_Switch:get_bool())
        Show(string.format("Rage>Anti-Aim>Angles>%s Defensive Pitch", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Defensive_Switch:get_bool())
        Show(string.format("Rage>Anti-Aim>Angles>%s Defensive Pitch Offset 1", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Defensive_Switch:get_bool() and builder_ui[i].Defensive_pitch:get_int() == 3)
        Show(string.format("Rage>Anti-Aim>Angles>%s Defensive Pitch Offset 2", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Defensive_Switch:get_bool() and builder_ui[i].Defensive_pitch:get_int() == 3)
        Show(string.format("Rage>Anti-Aim>Angles>%s Defensive Random Type", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Defensive_Switch:get_bool() and builder_ui[i].Defensive_pitch:get_int() == 4)
        Show(string.format("Rage>Anti-Aim>Angles>%s Defensive Random Min Amount", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Defensive_Switch:get_bool() and builder_ui[i].Defensive_pitch:get_int() == 4 and builder_ui[i].Defensive_Random_type:get_int() == 1)
        Show(string.format("Rage>Anti-Aim>Angles>%s Defensive Random Max Amount", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Defensive_Switch:get_bool() and builder_ui[i].Defensive_pitch:get_int() == 4 and builder_ui[i].Defensive_Random_type:get_int() == 1)
        Show(string.format("Rage>Anti-Aim>Angles>%s Defensive Custom Pitch", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Defensive_Switch:get_bool() and builder_ui[i].Defensive_pitch:get_int() == 5)

        Show(string.format("Rage>Anti-Aim>Angles>%s Defensive Yaw", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Defensive_Switch:get_bool())
        Show(string.format("Rage>Anti-Aim>Angles>%s Defensive Yaw Offset 1", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Defensive_Switch:get_bool() and builder_ui[i].Defensive_yaw:get_int() == 2)
        Show(string.format("Rage>Anti-Aim>Angles>%s Defensive Yaw Offset 2", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Defensive_Switch:get_bool() and builder_ui[i].Defensive_yaw:get_int() == 2)
        Show(string.format("Rage>Anti-Aim>Angles>%s Defensive Random Type Yaw", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Defensive_Switch:get_bool() and builder_ui[i].Defensive_yaw:get_int() == 3)
        Show(string.format("Rage>Anti-Aim>Angles>%s Defensive Random Min Amount Yaw", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Defensive_Switch:get_bool() and builder_ui[i].Defensive_yaw:get_int() == 3 and builder_ui[i].Defensive_random_type_yaw:get_int() == 1)
        Show(string.format("Rage>Anti-Aim>Angles>%s Defensive Random Max Amount Yaw", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Defensive_Switch:get_bool() and builder_ui[i].Defensive_yaw:get_int() == 3 and builder_ui[i].Defensive_random_type_yaw:get_int() == 1)
        Show(string.format("Rage>Anti-Aim>Angles>%s Defensive Custom Yaw", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Defensive_Switch:get_bool() and builder_ui[i].Defensive_yaw:get_int() == 4)

        Show(string.format("Rage>Anti-Aim>Desync>%s Roll", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and antiaim_ui.Other:get_int() == 3)
        Show(string.format("Rage>Anti-Aim>Desync>%s Roll Type", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Roll_switch:get_bool() and antiaim_ui.Other:get_int() == 3)
        Show(string.format("Rage>Anti-Aim>Desync>%s Roll Amount", aa_pizdec.conditions[i]), Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and state_enabled and state == i and builder_ui[i].Roll_switch:get_bool() and antiaim_ui.Other:get_int() == 3)
    end



    Show("Rage>Anti-Aim>Angles>Anti-Aim Type",Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1)
    Show("Rage>Anti-Aim>Desync>Other",Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1)
    Show("Rage>Anti-Aim>Desync>Freestand",Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and antiaim_ui.Other:get_int() == 0)
    Show("Rage>Anti-Aim>Desync>At Target",Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and antiaim_ui.Other:get_int() == 0)

    Show("Rage>Anti-Aim>Desync>Force Left",Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and antiaim_ui.Other:get_int() == 1)
    Show("Rage>Anti-Aim>Desync>Force Right",Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and antiaim_ui.Other:get_int() == 1)
    Show("Rage>Anti-Aim>Desync>Force Back",Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and antiaim_ui.Other:get_int() == 1)

    Show("Rage>Anti-Aim>Desync>Ground Breakers",Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and antiaim_ui.Other:get_int() == 2)
    Show("Rage>Anti-Aim>Desync>Air Breakers",Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and antiaim_ui.Other:get_int() == 2)
    Show("Rage>Anti-Aim>Desync>Other Breakers",Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and antiaim_ui.Other:get_int() == 2)
    Show("Rage>Anti-Aim>Desync>Meme Breakers",Tabs.Main:get_int() == 1 and Tabs.Rage:get_int() == 1 and antiaim_ui.Other:get_int() == 2 and antiaim_ui.breakers.other.meme.check:get_bool())
end

local st = 0
-- basic aa code
--@region: Fatality Anti-Aim
local function antiaim_builder(cmd,send_packet)
    local isSW = refereces.slide:get_bool()
    local lp = entities.get_entity(engine.get_local_player())
    local inAir = lp:get_prop("m_hGroundEntity") == -1
    local flag = lp:get_prop("m_fFlags")
    local crouch = bit.band(flag, 4) == 4
    local FD = refereces.FD:get_bool() == 1
    local FS  = refereces.Freestand:get_bool() == 1
    local OnGround = bit.band(flag,1) == 1;
    local hohol = bit.band(flag, 1) == 1;
    local velocity_x = lp:get_prop("m_vecVelocity[0]")
    local velocity_y = lp:get_prop("m_vecVelocity[1]")
    local velocity_z = lp:get_prop("m_vecVelocity[2]")

    local velocity = math.vec3(velocity_x, velocity_y, velocity_z)
    local Speed = math.ceil(velocity:length2d())
    if lp == nil then return end
    if not tools.get_active_exploit() and builder_ui[11].override:get_bool() then st = 11
    elseif (refereces.Freestand:get_bool()) and builder_ui[10].override:get_bool() then st = 10
    elseif (refereces.FD:get_bool()) and builder_ui[9].override:get_bool() then st = 9
    elseif (isSW and not inAir and not crouch and hohol) and builder_ui[8].override:get_bool() then st = 8 -- works / slowwalk
    elseif (inAir and crouch) and builder_ui[7].override:get_bool() then st = 7 -- works / air + crouch
    elseif inAir and builder_ui[6].override:get_bool() then st = 6 -- works / air
    elseif crouch and Speed > 5 and builder_ui[5].override:get_bool() then st = 5 -- works / crouch+move
    elseif crouch and Speed < 5 and builder_ui[4].override:get_bool() then st = 4 -- works / crouch
    elseif (hohol and Speed > 5) and builder_ui[3].override:get_bool() then st = 3  -- works / run
    elseif (hohol and Speed < 5) and builder_ui[2].override:get_bool() then st = 2  -- works / stand
    else st = 1 end -- Share

--{"Share", "Stand", "Run", "Crouch","Crouch+Move" ,"Air", "Air+C","Slow Walk","Fake Duck","Freestand", "Fake lag"}
    if antiaim_ui.AntiAim_type:get_int() == 0 then
        refereces.Pitch:set_int(builder_ui[st].pitch:get_int())
        refereces.Yaw_selection:set_int(builder_ui[st].yaw_base:get_int())
        if builder_ui[st].yaw:get_int() == 0 then
            refereces.Yaw:set_int(builder_ui[st].yaw_add:get_int())
            refereces.Yaw_Chck:set_bool(true)
        elseif builder_ui[st].yaw:get_int() == 1 then
            refereces.Yaw_Chck:set_bool(true)
            local delay_ticks = builder_ui[st].yaw_delay:get_int()
            local half_period = delay_ticks /2
            local current_tick = global_vars.tickcount % delay_ticks
            local should_switch = current_tick < half_period
            if send_packet == false then
                local yaw_offset = should_switch and -builder_ui[st].yaw_L:get_int() or builder_ui[st].yaw_R:get_int()
                refereces.Yaw:set_int(yaw_offset)
            end

            refereces.inverter:set_bool(should_switch)
        end
        if builder_ui[st].Jitter_type:get_int() == 1 then
            refereces.jitter:set_bool(true)
            refereces.jitterrange:set_int(builder_ui[st].jitter_range:get_int())
        elseif builder_ui[st].Jitter_type:get_int() == 2 then
            refereces.jitter:set_bool(true)
            refereces.jitterRandom:set_bool(true)
            refereces.jitterrange:set_int(builder_ui[st].jitter_range:get_int())
        else 
            refereces.jitterRandom:set_bool(false)
            refereces.jitterrange:set_int(0)
            refereces.jitter:set_bool(false)
        end
        if builder_ui[st].Desync_type:get_int() == 1 then
            refereces.Desync_Chck:set_bool(true)
            refereces.fakeamount:set_int(builder_ui[st].Desync_amount:get_int())
        elseif builder_ui[st].Desync_type:get_int() == 2 then
            refereces.Desync_Chck:set_bool(true) 
            local Desync_value = math.floor(math.abs(math.sin(global_vars.realtime*2) *2) * builder_ui[st].Desync_amount:get_int())
            if Desync_value > 200 then
                Desync_value = 200
            end
            refereces.fakeamount:set_int(-100+(Desync_value*2))
        elseif builder_ui[st].Desync_type:get_int() == 3 then
            if builder_ui[st].Random_type:get_int() == 0 then
                refereces.Desync_Chck:set_bool(true)
                refereces.fakeamount:set_int(math.random(-100,100))
            end
            if builder_ui[st].Random_type:get_int() == 1 then
                refereces.Desync_Chck:set_bool(true)
                refereces.fakeamount:set_int(math.random(-builder_ui[st].Random_amount_min:get_int(),builder_ui[st].Random_amount_max:get_int()))
            end
        end

        if builder_ui[st].Compansate_angle_type:get_int() == 1 then
            refereces.compensate:set_int(builder_ui[st].Compansate_angle_amount:get_int())
        elseif builder_ui[st].Compansate_angle_type:get_int() == 2 then
            if builder_ui[st].comp_Random_type:get_int() == 0 then
                refereces.compensate:set_int(math.random(-100,100))
            elseif builder_ui[st].comp_Random_type:get_int() == 1 then
                refereces.compensate:set_int(math.random(-builder_ui[st].comp_Random_amount_min:get_int(),builder_ui[st].comp_Random_amount_max:get_int()))
            end
        end
    end



    refereces.fsfake:set_int(builder_ui[st].Freestand_fake:get_int())
    refereces.Freestand:set_bool(antiaim_ui.freestand:get_bool())
    refereces.At_fov_target:set_bool(antiaim_ui.at_target:get_bool())
    refereces.Manual_left:set_bool(antiaim_ui.manual.left:get_bool())
    refereces.Manual_right:set_bool(antiaim_ui.manual.right:get_bool())
    refereces.Manual_back:set_bool(antiaim_ui.manual.back:get_bool())

end
--@endregion: Fatality Anti-Aim
--@region: Custom Anti-Aim
local function Defensive_aa(cmd)
    local isSW = refereces.slide:get_bool()
    local lp = entities.get_entity(engine.get_local_player())
    local inAir = lp:get_prop("m_hGroundEntity") == -1
    local flag = lp:get_prop("m_fFlags")
    local crouch = bit.band(flag, 4) == 4
    local FD = refereces.FD:get_bool() == 1
    local FS  = refereces.Freestand:get_bool() == 1
    local OnGround = bit.band(flag,1) == 1;
    local hohol = bit.band(flag, 1) == 1;
    local velocity_x = lp:get_prop("m_vecVelocity[0]")
    local velocity_y = lp:get_prop("m_vecVelocity[1]")
    local velocity_z = lp:get_prop("m_vecVelocity[2]")
    local weapon = lp:get_weapon():get_class()
    local velocity = math.vec3(velocity_x, velocity_y, velocity_z)
    local Speed = math.ceil(velocity:length2d())
    if lp == nil then return end
    if not tools.get_active_exploit() and builder_ui[11].override:get_bool() then st = 11
    elseif (refereces.Freestand:get_bool()) and builder_ui[10].override:get_bool() then st = 10
    elseif (refereces.FD:get_bool()) and builder_ui[9].override:get_bool() then st = 9
    elseif (isSW and not inAir and not crouch and hohol) and builder_ui[8].override:get_bool() then st = 8 -- works / slowwalk
    elseif (inAir and crouch) and builder_ui[7].override:get_bool() then st = 7 -- works / air + crouch
    elseif inAir and builder_ui[6].override:get_bool() then st = 6 -- works / air
    elseif crouch and Speed > 5 and builder_ui[5].override:get_bool() then st = 5 -- works / crouch+move
    elseif crouch and Speed < 5 and builder_ui[4].override:get_bool() then st = 4 -- works / crouch
    elseif (hohol and Speed > 5) and builder_ui[3].override:get_bool() then st = 3  -- works / run
    elseif (hohol and Speed < 5) and builder_ui[2].override:get_bool() then st = 2  -- works / stand
    else st = 1 end -- Share
    local flipJitter = false
    local fl_frozen = bit.lshift(1, 6)
    local in_attack = bit.lshift(1, 0)
    local in_attack2 = bit.lshift(1, 11) 
    local buttons = cmd:get_buttons()
    local e_key = input.is_key_down(0x45)
    local current_tick = global_vars.tickcount
    local me = entities.get_entity(engine.get_local_player())
    --print(weapon)
    if not me or not me:is_valid() then
        return
    end
    if weapon == nil then
        return
    end
    if lp:is_alive() == false then
        return
    end
    local checker = 0
    local defensive = false
    if bit.band(buttons, in_attack) == in_attack or bit.band(buttons, in_attack2) == in_attack2 or e_key then
        return
    end
    if (weapon == "CHEGrenade" or weapon == "CSmokeGrenade" or weapon == "CMolotovGrenade" or weapon == "CIncendiaryGrenade") then
        return
    end
    local pitches = 0
    if builder_ui[st].pitch:get_int() == 0 then
        pitches = 0
    elseif builder_ui[st].pitch:get_int() == 1 then
        pitches = 89
    elseif builder_ui[st].pitch:get_int() == 2 then
        pitches = -89 
    elseif builder_ui[st].pitch:get_int() == 3 then
        pitches = 0
    end
    local yaws = builder_ui[st].jitter_range:get_int()
    local pitch,yaw = engine.get_view_angles()
    local roll = 0
    if antiaim_ui.AntiAim_type:get_int() == 1 then

        if builder_ui[st].pitch:get_int() == 0 then
            pitch = 0
        elseif builder_ui[st].pitch:get_int() == 1 then
            pitch = 89
        elseif builder_ui[st].pitch:get_int() == 2 then
            pitch = -89
        elseif builder_ui[st].pitch:get_int() == 3 then
            pitch = 0
        end
                --{"None","Backwards","Zero","Random"}
        if builder_ui[st].yaw_base:get_int() == 0 then
            yaw = yaw + 0
        elseif builder_ui[st].yaw_base:get_int() == 1 then
            yaw = yaw - 180
        elseif builder_ui[st].yaw_base:get_int() == 2 then
            yaw = yaw + 0
        elseif builder_ui[st].yaw_base:get_int() == 3 then
            yaw = yaw + math.random(0,360)
        end
        if builder_ui[st].yaw:get_int() == 0 then
            yaw = yaw + builder_ui[st].yaw_add:get_int()
        elseif builder_ui[st].yaw:get_int() == 1 then
            local delay_ticks = builder_ui[st].yaw_delay:get_int()
            local half_period = delay_ticks /2
            local current_tick = global_vars.tickcount % delay_ticks
            local should_switch = current_tick < half_period
                local yaw_offset = should_switch and -builder_ui[st].yaw_L:get_int() or builder_ui[st].yaw_R:get_int()
                yaw = yaw + yaw_offset
        end
        if builder_ui[st].Jitter_type:get_int() == 1 then
                if global_vars.tickcount % 3 == 1 then
                    yaw = yaw + -builder_ui[st].jitter_range:get_int()
                elseif global_vars.tickcount % 3 == 2 then
                    yaw = yaw + builder_ui[st].jitter_range:get_int()
                end
        elseif builder_ui[st].Jitter_type:get_int() == 2 then
            if send_packet == true then
                refereces.jitterRandom:set_bool(true)
                if global_vars.tickcount % 3 == 1 then
                    yaw = yaw + -builder_ui[st].jitter_range:get_int()
                elseif global_vars.tickcount % 2 == 1 then
                    yaw = yaw + builder_ui[st].jitter_range:get_int()
                end
            end 
        end
        if builder_ui[st].Desync_type:get_int() == 1 then
            if send_packet == false then
                yaw = yaw + builder_ui[st].Desync_amount:get_int()
            end
        elseif builder_ui[st].Desync_type:get_int() == 2 then
            local Desync_value = math.floor(math.abs(math.sin(global_vars.realtime*2) *2) * builder_ui[st].Desync_amount:get_int())
            if Desync_value > 200 then
                Desync_value = 200
            end
            if send_packet == false then
                yaw = yaw + -100+(Desync_value*2)
            end
        elseif builder_ui[st].Desync_type:get_int() == 3 then
            if builder_ui[st].Random_type:get_int() == 0 then
                if send_packet == false then
                    yaw =  yaw + math.random(-100,100)
                end
            end
            if builder_ui[st].Random_type:get_int() == 1 then
                if send_packet == false then
                    yaw = yaw + math.random(-builder_ui[st].Random_amount_min:get_int(),builder_ui[st].Random_amount_max:get_int())
                end
            end
        end
            if builder_ui[st].Roll_switch:get_bool() then
                if builder_ui[st].Roll_type:get_int() == 0 then
                    roll = builder_ui[st].Roll_amount:get_int()
                elseif builder_ui[st].Roll_type:get_int() == 1 then
                    roll = math.random(-180,180)
                end
            end

            if antiaim_ui.manual.left:get_bool() then
                yaw = yaw - 90
            elseif antiaim_ui.manual.right:get_bool() then
                yaw = yaw + 90
            elseif antiaim_ui.manual.back:get_bool() then
                yaw = yaw + 180
            end
    end


    if builder_ui[st].Defensive_Switch:get_bool() then
        function on_create_move(cmd)
            local me = entities.get_entity(engine.get_local_player())
            if not me or not me:is_valid() then
                return
            end
        
            local tickbase = me:get_prop("m_nTickBase")
        
            defensive = math.abs(tickbase - checker) >= 2
            checker = math.max(tickbase, checker or 0)
        end
        if current_tick % builder_ui[st].Defensive_delay:get_int() == 0 then
            --                                                                   0        1          2        3         4       5
            if builder_ui[st].Defensive_pitch:get_int() == 0 then -- pitches {"Zero","Semi Up","Semi Down","Switch","Random","Custom"}
                pitch = 0
            elseif builder_ui[st].Defensive_pitch:get_int() == 1 then
                pitch = 89
                if current_tick % 3 == 2 then
                    pitch = 89
                elseif current_tick % 3 == 1 then
                    pitch = -45
                elseif current_tick % 3 == 0 then
                    pitch = -45
                end
            elseif builder_ui[st].Defensive_pitch:get_int() == 2 then
                pitch = -89
                if current_tick % 3 == 2 then
                    pitch = -89
                elseif current_tick % 3 == 1 then
                    pitch = 45
                elseif current_tick % 3 == 0 then
                    pitch = 45
                end
            elseif builder_ui[st].Defensive_pitch:get_int() == 3 then
                pitch = 0
                if current_tick % 3 == 2 then
                    pitch = builder_ui[st].Defensive_Switch1:get_int()
                elseif current_tick % 3 == 1 then
                    pitch = builder_ui[st].Defensive_Switch2:get_int()
                elseif current_tick % 3 == 0 then
                    pitch = builder_ui[st].Defensive_Switch2:get_int()
                end
            elseif builder_ui[st].Defensive_pitch:get_int() == 4 then
                if builder_ui[st].Defensive_Random_type:get_int() == 0 then -- random {"Natural","Min&Max"}
                    pitch = math.random(-89,89)
                elseif builder_ui[st].Defensive_Random_type:get_int() == 1 then
                    pitch = math.random(-builder_ui[st].Defensive_random_amount_min:get_int(),builder_ui[st].Defensive_random_amount_max:get_int())
                end
            elseif builder_ui[st].Defensive_pitch:get_int() == 5 then
                pitch = builder_ui[st].Defensive_custom:get_int()
            end
            if builder_ui[st].Defensive_yaw:get_int() == 0 then -- yaws {"None","Side-Ways","Switch","Random","Custom"}
                yaw = yaw + 0
            elseif builder_ui[st].Defensive_yaw:get_int() == 1 then -- side-ways
                if current_tick % 3 == 0 then
                    yaw = yaw + 90
                elseif current_tick % 3 == 1 then
                    yaw = yaw +  -90
                else yaw = yaw + 0
                end
            elseif builder_ui[st].Defensive_yaw:get_int() == 2 then -- switch
                if current_tick % 3 == 0 then
                    yaw = yaw + builder_ui[st].Defensive_yaw_offset1:get_int()
                elseif current_tick % 3 == 1 then
                    yaw = yaw + -builder_ui[st].Defensive_yaw_offset2:get_int()
                end
            elseif builder_ui[st].Defensive_yaw:get_int() == 3 then -- random
                if builder_ui[st].Defensive_random_type_yaw:get_int() == 0 then
                    yaw = yaw + math.random(-180,180)
                elseif builder_ui[st].Defensive_random_type_yaw:get_int() == 1 then
                    yaw = yaw + math.random(-builder_ui[st].Defensive_random_amount_yaw_min:get_int(),builder_ui[st].Defensive_random_amount_yaw_max:get_int())
                end
            elseif builder_ui[st].Defensive_yaw:get_int() == 4 then -- custom
                if current_tick % 3 == 0 then
                    yaw = yaw + builder_ui[st].Defensive_custom_yaw:get_int()
                elseif current_tick % 3 == 1 then
                    yaw = yaw + -builder_ui[st].Defensive_custom_yaw:get_int()
                end
            end
        end
    end
    if antiaim_ui.freestand:get_bool() then
        
    end
    cmd:set_view_angles(helpers.NormalizeAngle(pitch),helpers.NormalizeAngle(yaw), roll)
end
--@endregion: Custom Anti-Aim
--@region: Animationbreakers
local on_ground_ticks = 0
local offsets = {
    animstate = 0x9960, -- m_bIsScoped - 20
    m_pStudioHdr = 0x2950, -- https://github.com/frk1/hazedumper/blob/master/csgo.json#L55
    landing_anim = 0x109,
}

local breakers = {
    animation_breaker = function(frm)
        if frm ~= csgo.frame_render_start then return end
        if not entity.local_player().valid then return end
        local self_index = engine.get_local_player()
        local local_player = GetClientEntityFN(VClientEntityList, self_index)
        if not local_player then return end
        local in_air2 = false
        local flags = entity.local_player().prop("m_fFlags")
        if bit.band(flags, 1) == 0 then
            in_air2 = true
            if bit.band(flags, 4) == 4 then
                in_air2 = true
            end
        end
        local jitter = global_vars.tickcount % 2 == 0
        


        local animstate = ffi.cast( "void**", ffi.cast("unsigned int", local_player) + offsets.animstate)[0]

        if animstate == nil then
            return
        end
    
        animstate = ffi.cast("unsigned int", animstate)
    
        if animstate == 0x0 then
            return
        end
        local landing_anim = ffi.cast("bool*", animstate + offsets.landing_anim)[0]




        if antiaim_ui.breakers.ground:get_int() == 0 then
            refereces.Legs:set_int(2)
            if jitter then
                SetPose(local_player, 0, -179, 0)
            end
        elseif antiaim_ui.breakers.ground:get_int() == 1 then
            refereces.Legs:set_int(1)
            SetPose(local_player, 7, .5, 0)
        end
        if in_air2 == true then
            if antiaim_ui.breakers.air:get_int() == 0 then
                SetPose(local_player, 6, 0.9, 0)
            end
            if antiaim_ui.breakers.air:get_int() == 1 then
                if (utils.random_int(0, 1) == 0) then
                    SetPose(local_player, 6, 0, 1);
                else
                    SetPose(local_player, 6, 0.1, 0);
                end
            end
        end
        if antiaim_ui.breakers.other.lower_body_yaw:get_bool() then
            SetPose(local_player, 10, 0, 0);
        end
        if antiaim_ui.breakers.other.meme.check:get_bool() then
            if antiaim_ui.breakers.other.meme.fd:get_bool() then
                if refereces.FD:get_bool() then
                    if (utils.random_int(0, 5) == 0) then
                        SetPose(local_player, 16, 0, 0);
                    else
                        SetPose(local_player, 16, 10, 0);
                    end
                end
            end
        end
        if antiaim_ui.breakers.other.pitch_on_land:get_bool() then
            if on_ground_ticks > 12 and landing_anim then
                SetPose(local_player, 12, 0.999, 1)
            end
        end
    end
}
--@endregion: Animationbreakers




--@region: Ragebot
aimbot_func.better_dt = function()
    if aimbot_ui.improve_dt:get_bool() then
        cvar.sv_maxusrcmdprocessticks:set_float(aimbot_ui.better_dt_slider:get_float())
    else
        cvar.sv_maxusrcmdprocessticks:set_float(16)
    end
    tools.force_charge(refereces.DT)
    --tools.force_teleportdt()
end



--@endregion: Ragebot







--@region: Misc
-------------------------------------------------
local advertisement = {
    "EZ owned by atlantic.oce",
   "Get better get atlantic.oce",
   "I see your lua suck i think you should buy atlantic.oce on discord: 32Jcnkx75E",
   "Bored of using pasted luas? go use atlantic.oce instead",
   "get 1'ed by atlantic.oce",
   "unlock your full potential with atlantic.oce",
   "want to be best version of your self? use atlantic.oce",
   "atlantic.oce just made your kd worse",
   "Anotha day, anotha carry by atlantic.oce",
   "Anotha no named downed by atlantic.oce",
   "Imagine still not using atlantic.oce",
   "Bro its 2024 and you are not using atlantic.oce",
   "Atlantic.oce Best Lua ever done that only you can wish for",
   "You think you can escape from Atlantic.oce power? you are wrong kiddo"
}

local medusa_uno = {
"Be humiliated because you just got 1 by Medusa.uno",
"OwO, what is this? Medusa.uno just made your kd worse",
"YOUR DEAD, IMAGINE, GET 1'ED BY MEDUSA.UNO",
"Get good, sting to death with Medusa.uno",
"Another no name down by Medusa.uno",
"UwU stings you to death cutely using Medusa.uno",
"Medusa.uno just stinged ur ass $$$$$",
"Just saw something, a 1 in my killfeed caused by Medusa.uno",
"Why you keep to see 1 caused by Medusa.uno",
"Knock Knock Who there? Medusa.uno here to take exterminate the no names!",
"Taking down some no names? How about you get yourself Medusa.uno and rape em >:}",
"Anotha day, anotha carry by Medusa.uno",
"Sit the fuck down no name, Medusa.uno will always be superior",
"WOMP WOMP GET 1'ED BY MEDUSA.UNO",
"What was that? No namer dying? Womp womp, Medusa.uno is yo feudal leader",
"^=^ Woo hoo, anotha no named downed by Medusa.uno",
"Who this? No name dying to Medusa.uno? Womp womp."
}

local toxic = {
"Why you are as that EZ",
"Bro fucking leave, this game is wast of your time",
"1 Sit nn Dog"
}
--basic killsay
misc_func.killsay = function(event)
    local attacker = engine.get_player_for_user_id(event:get_int('attacker'));
    local userid = engine.get_player_for_user_id(event:get_int('userid'));
    local userInfo = engine.get_player_info(userid);
    local lp = engine.get_local_player();
    if attacker == lp and userid ~= lp then
        if misc_ui.kys:get_int() == 0 then
            engine.exec("say " .. advertisement[utils.random_int(1, #advertisement)])
        elseif misc_ui.kys:get_int() == 1 then
            engine.exec("say " .. medusa_uno[utils.random_int(1, #medusa_uno)])   
        elseif misc_ui.kys:get_int() == 2 then 
            engine.exec("say " .. toxic[utils.random_int(1, #toxic)])                                                          
        elseif misc_ui.kys:get_int() == 3 then
            engine.exec("say 1")
        end
    end
end


function misc_func.ct()
    --misc_ui.ct = combo("Clantags","Rage>Anti-Aim>Angles", {"OFF", "Atlantic.oce", "Medusa.uno"})
    if misc_ui.ct:get_int() == 1 then
        tools.animated_clantag(3,{
            "A", "At", "Atl", "Atla", "Atlan", "Atlant", "Atlanti", "Atlantic",
            "Atlantic.", "Atlantic.o", "Atlantic.oce", "Atlantic.oc", "Atlantic.o",
            "Atlantic.", "Atlantic", "Atlanti", "Atlant", "Atlan", "Atla", "Atl",
            "At", "A", "",
        })
    elseif misc_ui.ct:get_int() == 2 then
        tools.animated_clantag(3,{
            "Medusa.un|", "Medusa.uno", "Medusa.uno", "Medusa.uno", "Medusa.uno",
            "Medusa.uno", "Medusa.uno", "Medusa.un|", "Medusa.u/", "Medusa|",
            "Medus/", "Medu/", "Med|", "Me/", "M/", " | ", "M/", "Me/",
            "Med|", "Medu/", "Medus/", "Medusa|", "Medusa./", "Medusa.u/",
        })
    else 
        tools.animated_clantag(1,{""})
    end
end

local function Forward(angle)
    local pitch = math.rad(angle.x) -- Convert pitch to radians
    local yaw = math.rad(angle.y)   -- Convert yaw to radians

    local forward = math.vec3(
        math.cos(pitch) * math.cos(yaw),
        math.cos(pitch) * math.sin(yaw),
        -math.sin(pitch)
    )

    return forward
end

--@region: Super Toss
helpers.ang_vec = function(ang) 
    return math.vec3(math.cos(ang.x * math.pi / 180) * math.cos(ang.y * math.pi / 180), math.cos(ang.x * math.pi / 180) * math.sin(ang.y * math.pi / 180), -math.sin(ang.x * math.pi / 180))
end
local function to_angle(vector)
    local pitch, yaw

    if vector.x == 0 and vector.y == 0 then
        pitch = vector.z > 0 and 270 or 90 -- Straight up or down
        yaw = 0
    else
        pitch = math.deg(math.atan2(-vector.z, math.sqrt(vector.x * vector.x + vector.y * vector.y)))
        yaw = math.deg(math.atan2(vector.y, vector.x))
        if yaw < 0 then
            yaw = yaw + 360 -- Normalize yaw to the range [0, 360)
        end
    end

    return { x = pitch, y = yaw, z = 0 } -- Returning as an angle table
end

helpers.target_angles = math.vec3(0, 0, 0)
misc_func.toss = function(cmd)
    local toss = {}
    if misc_ui.super_toss:get_int() == 0 then return end
    local lplr = entities.get_entity(engine.get_local_player())
    if not lplr or not lplr:is_alive() then return end
    if (lplr:get_prop("m_MoveType") == 9) then return end
    local weapon = lplr:get_weapon()
    if not weapon then return end
    local view_x, view_y, view_z = cmd:get_view_angles()
    view_x = -89
    local data = tools.get_weapon_info()
    if not data then return end
    toss.view_x, toss.view_y = engine.get_view_angles()
    
    if not weapon:get_prop("m_flThrowStrength") then return end
    
    local ang_throw = math.vec3(view_x, toss.view_y , 0)
    ang_throw.x = ang_throw.x - (90 - math.abs(ang_throw.x)) * 10 / 90
    ang_throw = helpers.ang_vec(ang_throw)

    local throw_strength = animations.math_clamp(weapon:get_prop("m_flThrowStrength"), 0, 1)
    local fl_velocity = animations.math_clamp(data.throw_velocity * 0.9, 15, 750)
    fl_velocity = fl_velocity * (throw_strength * 0.7 + 0.3)
    fl_velocity = math.vec3(fl_velocity, fl_velocity, fl_velocity)


    local velocity_x = lplr:get_prop("m_vecVelocity[0]")
    local velocity_y = lplr:get_prop("m_vecVelocity[1]")
    local velocity_z = lplr:get_prop("m_vecVelocity[2]")
    local scaled_velocity = math.vec3(velocity_x * 1.45, velocity_y * 1.45, velocity_z * 1.45)
    local velocity = math.vec3(velocity_x, velocity_y, velocity_z)
    local vec_throw = (Forward(ang_throw) * fl_velocity + velocity * math.vec3(1.45, 1.45, 1.45))
    vec_throw = to_angle(vec_throw)
    local yaw_difference = toss.view_y - vec_throw.y
    while yaw_difference > 180 do
        yaw_difference = yaw_difference - 360
    end
    while yaw_difference < -180 do
        yaw_difference = yaw_difference + 360
    end
    local pitch_difference = toss.view_x - vec_throw.x - 10
    while pitch_difference > 90 do
        pitch_difference = pitch_difference - 45
    end
    while pitch_difference < -90 do
        pitch_difference = pitch_difference + 45
    end
    helpers.target_angles.y = toss.view_y + yaw_difference
    helpers.target_angles.x = animations.math_clamp(toss.view_x + pitch_difference, -89, 89)

    view_y = helpers.target_angles.y
    if misc_ui.super_toss:get_int() == 1 then
        local flags = lplr:get_prop("m_fFlags")
        local airborne = bit.band(flags, bit.lshift(1, 0)) == 0
        if airborne then
            view_x = helpers.target_angles.x
        end
    elseif misc_ui.super_toss:get_int() == 3 then
        view_x = helpers.target_angles.x
    end

end

--@endregion: Misc










--@region: Visuals
-------------------------------------------------

local offset = 0
-- Crosshair indicators function
visuals_func.crosshair_ind = function()
    -- Ensure player is in-game and indicator switch is enabled
    if not engine.is_in_game() or not visuals_ui.crosshair_ind.switch:get_bool() then return end

    -- Get local player and scope status
    local lp = entities.get_entity(engine.get_local_player())
    if not lp then return end -- Check if local player exists
    local scoped = lp:get_prop('m_bIsScoped')

    -- Smooth transition for offset based on scope status
    offset = animations.lerp_new(offset, scoped and 50 or 0, 20)
    -- Screen dimensions
    local x, y = render.get_screen_size()
    local center_x, center_y = x / 2, y / 2 + visuals_ui.crosshair_ind.y:get_int()

    -- State texts
    local state_texts = {
        [1] = "Share", [2] = "Stand", [3] = "Run",
        [4] = "Crouch", [5] = "Crab+Move", [6] = "Air",
        [7] = "Air+C", [8] = "Slow-Walk", [9] = "Fake Duck",
        [10] = "Freestand", [11] = "Fake Lag"
    }

    -- Define `st` based on current game state or condition
    local text_state = state_texts[st] or ""

    -- Bind indicators and names
    local bind_names = {
        "Freestand", "DMG", "Target Dormant",
        "Peek Assist", "Fake Duck", "Double Tap", "Hide Shot"
    }
    local binds = {
        Find("Rage>Anti-Aim>Angles>Freestand"):get_bool(),
        Find("rage>aimbot>ssg08>scout>override"):get_bool(),
        Find("rage>aimbot>aimbot>target dormant"):get_bool(),
        Find("Misc>Movement>Peek Assist"):get_bool(),
        Find("Misc>Movement>Fake Duck"):get_bool(),
        Find("Rage>aimbot>aimbot>double tap"):get_bool(),
        Find("Rage>aimbot>aimbot>Hide Shot"):get_bool()
    }

    -- Define background box dimensions and position
    local padding = 5
    local box_width = 100
    local box_height = 40
    local box_x1 = center_x + offset - (box_width / 2) - padding
    local box_y1 = center_y - padding
    local box_x2 = center_x + offset + (box_width / 2) + padding
    local box_y2 = center_y + box_height + padding

    -- Render main background box with padding
    render.rect_filled_rounded(box_x1, box_y1, box_x2, box_y2, render.color(0, 0, 0, 100), 5, render.all)

    -- Render "Atlantic.oce" text centered within the background
    render.text(fonts.verdana, center_x + offset, center_y, "Atlantic.oce", render.color("#FFFFFF"), render.align_center)

    -- Draw dividing line between "Atlantic.oce" and `text_state`
    local line_y = center_y + 20 -- Position the line slightly below "Atlantic.oce" text
    render.rect(box_x1, line_y, box_x2, line_y + 1, render.color("#00FFFF")) -- Adjust color as desired

    -- Render the state text below the dividing line
    render.text(fonts.verdana, center_x + offset, center_y + 20, text_state, render.color("#FFFFFF"), render.align_center)

    -- Optional: Outline the background box
    render.rect(box_x1, box_y1, box_x2, box_y2, render.color("#00FFFF"))







    -- Check for active binds and calculate their count
    local active_binds = 0
    for _, is_active in ipairs(binds) do
        if is_active then
            active_binds = active_binds + 1
        end
    end

    -- Only render the box if there are active binds
    if active_binds > 0 then
        -- Define box dimensions and position
        local padding = 5
        local box_width = 100
        local indicator_box_x1 = center_x + offset - (box_width / 2) - padding
        local indicator_box_y1 = center_y + 47
        local bind_box_height = (active_binds * 20) + padding * 2
        local indicator_box_x2 = center_x + offset + (box_width / 2) + padding
        local indicator_box_y2 = indicator_box_y1 + bind_box_height

        -- Render background box for active bind indicators
        render.rect_filled_rounded(indicator_box_x1, indicator_box_y1, indicator_box_x2, indicator_box_y2, render.color(0, 0, 0, 100), 5, render.all)

        -- Optional: Outline for the bind indicators box
        render.rect(indicator_box_x1, indicator_box_y1, indicator_box_x2, indicator_box_y2, render.color("#00FFFF"))

        -- Render each active bind indicator text inside the box
        local offset_y = 0
        for i, is_active in ipairs(binds) do
            if is_active then
                render.text(fonts.verdana, center_x + offset, center_y + 52 + offset_y, bind_names[i], render.color("#FFFFFF"), render.align_center)
                offset_y = offset_y + 20
            end
        end
    end
end





visuals_func.side_indicators = function()
    local lp = entities.get_entity(engine.get_local_player())
    if not lp then return end

    local x, y = render.get_screen_size()

    if visuals_ui.side_ind:get_bool() then
        local bind_names = {
            "Freestand", "DMG", "Target Dormant",
            "Peek Assist", "Fake Duck", "Double Tap", "Hide Shot"
        }
        local binds = {
            Find("Rage>Anti-Aim>Angles>Freestand"):get_bool(),
            Find("rage>aimbot>ssg08>scout>override"):get_bool(),
            Find("rage>aimbot>aimbot>target dormant"):get_bool(),
            Find("Misc>Movement>Peek Assist"):get_bool(),
            Find("Misc>Movement>Fake Duck"):get_bool(),
            Find("Rage>aimbot>aimbot>double tap"):get_bool(),
            Find("Rage>aimbot>aimbot>Hide Shot"):get_bool()
        }
        local offset_y = 0 
        for i, value in pairs(binds) do
            if value then
                local clr = render.color(249, 250, 247)
                render.text(fonts.verdana, 10, y/ 2 + 100 + 35 +offset_y , bind_names[i], clr)
                offset_y = offset_y + 20
            end
        end
    end
end











--@endregion: Visuals
--@region: Logs

-- Logger function to log entries
local function logger(entry)
    -- Check if the entry is a string or a table
    if type(entry) == "string" then
        -- Convert string to table format with default color
        entry = { { text = entry, clr = render.color(255, 255, 255) } }
    elseif type(entry) ~= "table" then
        error("Expected a string or table for log entry")
    end

    -- Add log entry with the current timestamp
    table.insert(logs, {
        data = entry,              -- Store structured log data
        alpha = 255,               -- Set initial alpha for fade effect
        timestamp = global_vars.curtime,
        slide_offset = 0,          -- Initialize sliding offset for moving effect
    })

    -- Concatenate all text elements in `entry` into a single line
    local log_text = ""
    for _, line in ipairs(entry) do
        log_text = log_text .. line.text .. " "
    end

    if visuals_ui.logs_type.event then
        print(log_text:match("^%s*(.-)%s*$"))
    end
    if visuals_ui.logs_type.console then
        utils.print_console(log_text:match("^%s*(.-)%s*$"))
    end
    if #logs > 5 then
        table.remove(logs, 1) -- Remove the oldest log if there are more than 5
    end
end


visuals_func.render_logs = function()
    if not visuals_ui.logs_type.screen:get_bool() then return end

    -- Get the selected DPI scale from the combo box
    local selected_dpi_scale = tonumber(info.dpi_scale_table[info.dpi_scale:get_int() + 1])

    local screen_x, screen_y = render.get_screen_size()
    local position_x = screen_x / 2
    local initial_y_position = screen_y / 2 + 300 * selected_dpi_scale
    local log_spacing = 40 * selected_dpi_scale -- Space between logs

    -- Process and render logs
    for i = #logs, 1, -1 do  -- Iterate backwards to safely remove items
        local log = logs[i]

        -- Check if the log should still be visible
        if global_vars.curtime - log.timestamp < 3.0 then
            log.alpha = 255 -- Keep full alpha for the first 3 seconds
        else
            log.alpha = log.alpha - 5 -- Decrease alpha for fade effect
            log.slide_offset = log.slide_offset + 1 * selected_dpi_scale -- Slide down after 3 seconds
        end

        -- If alpha is less than or equal to 0, remove the log
        if log.alpha <= 0 then
            table.remove(logs, i)
        else
            -- Calculate the vertical position for each log
            local log_y_position = initial_y_position + log.slide_offset + (i - 1) * log_spacing

            -- Draw a background rectangle for better visibility
            render.rect_filled_rounded(position_x - 150 * selected_dpi_scale, log_y_position - 10 * selected_dpi_scale,
                                       position_x + 150 * selected_dpi_scale, log_y_position + 10 * selected_dpi_scale,
                                       render.color(0, 0, 0, log.alpha), 5 * selected_dpi_scale, render.all)

            -- Render each part of the structured log entry
            local text_offset = 0
            for _, part in ipairs(log.data) do
                local color = part.clr or render.color(255, 255, 255, log.alpha) -- Default to white if no color

                if visuals_ui.logs:get_int() == 1 then
                    -- Render each part as centered text
                    render.text(fonts.verdana, position_x + text_offset - 100 * selected_dpi_scale, log_y_position, part.text, color)
                elseif visuals_ui.logs:get_int() == 2 then
                    -- Render each part as left-aligned text
                    render.text(fonts.verdana, position_x + text_offset - 100 * selected_dpi_scale, log_y_position, part.text, color)
                end
                
                -- Update text offset for the next part
                local text_width, _ = render.get_text_size(fonts.verdana, part.text) -- Get width for the current part
                text_offset = text_offset + text_width * selected_dpi_scale -- Update text offset for next part
            end
        end
    end
end







--@region: Watermark
function visuals_func.watermark()
    if not visuals_ui.watermark:get_bool() then return end

    -- Get the selected DPI scale from the combo box
    local selected_dpi_scale = tonumber(info.dpi_scale_table[info.dpi_scale:get_int() + 1]) or 1.0

    -- Update font with current DPI scale
    update_font()

    local x, y = render.get_screen_size()
    local player = engine.get_local_player()
    local player_info = engine.get_player_info(player)

    -- Calculate round-trip time
    local rtt_ms = 0
    local rtt = utils.get_rtt()
    if rtt ~= nil then
        rtt_ms = math.floor(rtt * 500)
    end

    -- Get current time and format the watermark text
    local current_time = utils.get_time()
    local text = "Atlantic.oce | " .. player_info.name .. " | " .. rtt_ms .. "ms | " .. current_time.hour .. ":" .. current_time.min .. ":" .. current_time.sec
    local text_x, text_y = render.get_text_size(fonts.verdana, text)

    -- Adjust positioning and dimensions based on the DPI scale
    local offset_x = 15 * selected_dpi_scale
    local offset_y = 16 * selected_dpi_scale
    local text_padding_x = 10 * selected_dpi_scale
    local text_padding_y = 5 * selected_dpi_scale
    local rounded_corner_radius = 4 * selected_dpi_scale

    -- Render background rectangles and text with DPI-scaled offsets
    render.rect_filled_rounded(x - offset_x, offset_y, x - text_x - offset_x - text_padding_x, text_y + offset_y + text_padding_y, 
                               render.color(0, 0, 0, visuals_ui.watermark_alpha:get_int()), rounded_corner_radius, render.all)
    render.rect_filled_rounded(x - offset_x, offset_y - 2, x - text_x - offset_x - text_padding_x, text_y - text_padding_y, 
                               visuals_ui.watermark_color:get_color(), rounded_corner_radius, render.all)
    render.text(fonts.verdana, x - text_x - offset_x + 5, offset_y, text, render.color(255, 255, 255, 255))
end







visuals_func.menu_watermark = function()
    if not visuals_ui.watermark:get_bool() then return end
    local menupos_x1, menupos_y1, menupos_x2, menupos_y2 = gui.get_menu_rect()
    local textsize_w, textsize_h = render.get_text_size(fonts.verdana, "Fatality.Win")
    if gui.is_menu_open() == true then
        render.text(fonts.verdana, menupos_x2 - textsize_w - 350  , menupos_y1 - textsize_h - 10, "Atlantic.oce", render.color(255, 255, 255, 255))
    end
end




on_shot_registered = function(s)
    local reasons = {
        ['resolve'] = 'Correction',
        ['extrapolation'] = 'Extrapolation',
        ['spread'] = 'Spread',
        ['server correction'] = 'Unregistered shot',
        ['anti-exploit'] = 'Anti-Exploit'
    }
    local color_map = {
        ['spread'] = render.color('#ffee00'),
        ['server correction'] = render.color('#7285c4'),
        default = render.color('#ff0000')
    }
    local target_name = engine.get_player_info(s.target).name
    local color = color_map[s.result] or color_map.default
    local hitgroup_str = {
        [0] = 'generic', 'head', 'chest', 'stomach',
        'left arm', 'right arm', 'left leg', 'right leg',
        'neck', 'generic', 'gear'
    }
    local hitbox = hitgroup_str[s.server_hitgroup] or 'unknown'
    if s.result ~= "hit" then
        if not s.manual then
            -- Create a log with colorized target name and reason
            logger({
                { text = "Missed ", clr = render.color(255, 255, 255) },
                { text = target_name, clr = render.color(255, 0, 0) },
                { text = " due to ", clr = render.color(255, 255, 255) },
                { text = reasons[s.result], clr = color }
            })
        end
    elseif s.result == "hit" then
        logger({
            { text = "Registed Hit to ", clr = render.color(255, 255, 255) },
            { text = target_name, clr = render.color(0, 255, 0) },
            { text = " in ", clr = render.color(255, 255, 255)},
            { text = hitbox, clr = render.color(0, 255, 0) }}
        )
            
    end
end







--@region: Removing OLD menu
-------------------------------------------------
ui.remove_menu = function()
    Show("Rage>Anti-Aim>Angles>Anti-aim",false)
    Show("Rage>Anti-Aim>Angles>Yaw",false)
    Show("Rage>Anti-Aim>Angles>Freestand",false)
    Show("Rage>Anti-Aim>Angles>Pitch",false)
    Show("Rage>Anti-Aim>Angles>Yaw add",false)
    Show("Rage>Anti-Aim>Angles>Add",false)
    Show("Rage>Anti-Aim>Angles>At fov target",false)
    Show("rage>anti-aim>angles>jitter range",false)
    Show("rage>anti-aim>Angles>spin",false)
    Show("rage>anti-aim>angles>jitter",false)
    Show("rage>anti-aim>angles>Antiaim override",false)
    Show("rage>anti-aim>angles>Back",false)
    Show("rage>anti-aim>angles>Left",false)
    Show("rage>anti-aim>angles>Right",false)
    Show("rage>anti-aim>angles>Random",false)

    Show("rage>anti-aim>desync>freestand fake",false)
    Show("rage>anti-aim>desync>Flip fake with jitter",false)
    Show("rage>anti-aim>desync>fake",false)
    Show("rage>anti-aim>desync>fake amount",false)
    Show("rage>anti-aim>desync>compensate angle",false)
    Show("rage>anti-aim>desync>Leg slide",false)
    Show("rage>anti-aim>desync>Roll lean",false)
    Show("rage>anti-aim>desync>Ensure lean",false)
    Show("rage>anti-aim>desync>Flip lean with jitter",false)
    Show("rage>anti-aim>desync>Lean amount",false)
end

--@region: Config System
-------------------------------------------------
function Configs_sys.export()
    local value = config.export({builder_ui, antiaim_ui, visuals_ui, misc_ui})
    tools.set_clipboard("Atlantic.oce: "..value)
end

configs_ui.import = gui.add_button("Import", "Rage>Anti-Aim>Desync", function()
    local config_data = tools.import()
    
end)
configs_ui.export = gui.add_button("Export", "Rage>Anti-Aim>Desync",function()
    Configs_sys.export()
end)

ui.config_menu = function()
    Show("Rage>Anti-Aim>Desync>Export",Tabs.Main:get_int() == 2 and Tabs.Other:get_int() == 1)
    Show("Rage>Anti-Aim>Desync>Import",Tabs.Main:get_int() == 2 and Tabs.Other:get_int() == 1)
end





--@region: Callbacks
-------------------------------------------------
callbacks.Menu = function()
    ui.remove_menu()
    ui.new_menu()
    ui.AntiAim_menu()
    ui.config_menu()
end
callbacks.render = function()
    misc_func.ct()
    visuals_func.crosshair_ind()
    visuals_func.watermark()
    visuals_func.render_logs()
    visuals_func.side_indicators()
    visuals_func.menu_watermark()
end
callbacks.AntiAim = function(cmd)
    antiaim_builder(cmd)
end
callbacks.target_death = function(event)
    if misc_ui.kys_switch:get_bool() then
        misc_func.killsay(event)
    end
end



function on_player_death(event)
    callbacks.target_death(event)
end
function on_paint()
    callbacks.Menu()
    callbacks.render()
end
function on_create_move(cmd,send_packet)
    callbacks.AntiAim(cmd,send_packet)
    aimbot_func.better_dt()
end
-- bc of this callback defensive doesnt work on atalntic aa type but if we dont use it whole lua will lag and be broken(i can fix it but im to lazy)
function on_run_command(cmd)
    Defensive_aa(cmd)
    misc_func.toss(cmd)
end


function on_frame_stage_notify(frm, pr)
    for _, func in pairs(breakers) do
        call(func(frm, pr))
    end
end

function on_setup_move(cmd)
    local self_index = engine.get_local_player()
    local local_player = GetClientEntityFN(VClientEntityList, self_index)
    local NULL = 0x0

    if not local_player or local_player == NULL then
        return
    end
    local me = entities.get_entity(engine.get_local_player())
    local on_ground = bit.band(me:get_prop("m_fFlags"),1)
    if on_ground == 1 then
        on_ground_ticks = on_ground_ticks + 1
    else
        on_ground_ticks = 0
    end

    local pose_parameters_cache = animation_breakers.collected_cache

    for key, cache in pairs(pose_parameters_cache) do
        SetPose(local_player, key)
    end
end
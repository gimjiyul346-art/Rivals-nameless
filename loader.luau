
게임이 로드될 때까지 wait()를 반복합니다.

getgenv().lilix = getgenv().lilix 또는 nil
getgenv().relix = getgenv().relix 또는 nil

getgenv().key = getgenv().key 또는 nil
getgenv().luarmor_api = getgenv().luarmor_api 또는 nil
getgenv().key_expire = getgenv().key_expire 또는 nil
getgenv().key_note = getgenv().key_note 또는 nil
getgenv().key_executions = getgenv().key_executions 또는 nil

LPH_OBFUSCATED가 아니면
	LPH_JIT_MAX = 함수(...) 반환 ... 끝
	LPH_NO_VIRTUALIZE = function(f) return f end
	LPH_NO_UPVALUES = function(...) return ... end
	LPH_CRASH = function(...) return ... end
또 다른
	print = function() end
	경고 = 함수() 끝
끝

로컬 클론 참조 = 클론 참조 또는 함수(o) 반환 o 끝
local CoreGui = cloneref(game:GetService("CoreGui"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
로컬 플레이어 = cloneref(game:GetService("Players"))
local TextService = cloneref(game:GetService("TextService"))
local HttpService = cloneref(game:GetService("HttpService"))
로컬 조명 = cloneref(game:GetService("Lighting"))
local StarterGui = cloneref(game:GetService("StarterGui"))
로컬 워크스페이스 = cloneref(game:GetService("워크스페이스"))
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled

로컬 폴더 구성 = {
	디렉토리 = "solixhub",
	자산 = "solixhub/Assets",
	설정 = "solixhub/Configs",
	데이터 = "solixhub/Datas",
	이미지 = "solixhub/Images",
	테마 = "solixhub/Themes"
}

_, Folder_Configs의 Folder에 대해 다음을 수행합니다.
	만약 isfolder(폴더)가 아니라면
		폴더 만들기(폴더)
	끝
끝

로컬 게임 ID = tostring(game.GameId)
로컬 GameConfigFolder = Folder_Configs.Configs .. "/" .. GameId

만약 해당 폴더가 GameConfigFolder가 아니라면
	makefolder(게임 설정 폴더)
끝

로컬 게임 목록 = {
	["3808223175"] = { id = "4fe2dfc202115670b1813277df916ab2", keyless = false }, -- 인피니트 주술
	["994732206"] = { id = "e2718ddebf562c5c4080dfce26b09398", keyless = false }, -- 블록스 과일
	["1511883870"] = { id = "fefdf5088c44beb34ef52ed6b520507c", keyless = false }, -- 신도 라이프
	["245662005"] = { id = "21ad7f491e4658e9dc9529a60c887c6e", keyless = true }, -- 탈옥
	["7018190066"] = { id = "98f5c64a0a9ecca29517078597bbcbdb", keyless = true }, -- 데드 레일즈
	["7326934954"] = { id = "00e140acb477c5ecde501c1d448df6f9", keyless = true }, -- 숲 속의 99일 밤
	["7671049560"] = { id = "c0b41e859f576fb70183206224d4a75f", keyless = false }, -- 더 포지
	["9363735110"] = { id = "4948419832e0bd4aa588e628c45b6f8d", keyless = false }, -- 뇌 손상을 위한 쓰나미 탈출!
	["5130394318"] = { id = "3e7a75a970118d0f0cf629369524dc7d", keyless = false }, -- 기묘한 계보
	["9186719164"] = { id = "892ccfefdc8834199a2a6e5856a8da67", keyless = true }, -- 세일러 피스
	["9787206684"] = { id = "a29d0ba0c834bf7d9ccd4b615fce834f", keyless = false }, -- 행운의 블록이 되세요
	["9875383684"] = { id = "e29724bc620c1a6d1a45818c4f71b1d0", keyless = false }, -- 뇌썩음병에 걸리다
	["4658598196"] = { id = "52cc23f3d78c16c959b080fca6d9cd54", keyless = false } -- 진격의 거인 레볼루션
}

로컬 구성 = {
	파일 = "solixhub/savedkey.txt",
	제목 = "솔릭스 허브 무료 게임 15개 이상"
	설명 = "solixhub.com을 통해 15달러를 일회성으로 결제하시면 평생 이용 가능한 키에 액세스할 수 있습니다."
	Linkvertise = "https://ads.luarmor.net/get_key?for=Solix_Hub_Linkvertise-OWlLHDMCHADk",
	린쿠 = "https://ads.luarmor.net/get_key?for=Solix_Hub_Rinku-pqJCGTqnTsng",
	디스코드 = "https://discord.gg/solixhub",
	쇼핑몰 = "https://solixhub.com/",
}

로컬 오류 메시지 = {
	KEY_EXPIRED = "사용자 키가 만료되었습니다. 계속하려면 키를 갱신하세요."
	KEY_BANNED = "이 키는 블랙리스트에 등록되었습니다. 지원팀에 문의하여 도움을 받으세요."
	KEY_INCORRECT = "제공된 키가 잘못되었거나 더 이상 유효하지 않습니다."
	KEY_INVALID = "잘못된 키 형식입니다. 키를 확인하고 다시 시도하십시오."
	SCRIPT_ID_INCORRECT = "제공된 스크립트 ID가 존재하지 않거나 삭제되었습니다."
	SCRIPT_ID_INVALID = "이 스크립트는 소유자에 의해 삭제되었습니다."
	SECURITY_ERROR = "보안 유효성 검사에 실패했습니다(Cloudflare 검사). 다시 시도해 주세요."
	TIME_ERROR = "잘못된 클라이언트 시간이 감지되었습니다. 시스템 시계를 동기화하십시오."
	UNKNOWN_ERROR = "알 수 없는 오류가 발생했습니다. 지원팀에 문의하십시오."
}

로컬 GameConfig = GameList[GameId]

GameConfig가 아니면
	StarterGui:SetCore("알림 보내기",{
		제목 = "솔릭스 허브",
		텍스트 = "이 게임은 지원되지 않습니다.",
		아이콘 = "rbxassetid://137698471325689",
	})
	반품
끝

로컬 ScriptId = GameConfig.id
로컬 IsKeyless = GameConfig.keyless

hookfunction과 hookmetamethod가 있으면
	getgenv().lilix = true
또 다른
	getgenv().lilix = false
끝

IsMobile이면
	getgenv().relix = true
또 다른
	getgenv().relix = false
끝

로컬 함수 DeleteFile(v)
	if isfile(v)이면
		delfile(v)
	끝
끝

local LuarmorApi = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
LuarmorApi.script_id = ScriptId

IsKeyless이면
	pcall(함수()
		LuarmorApi.load_script()
	끝)
	반품
끝

지역 도서관
	로컬 대기 = 작업 대기
	로컬 스폰 = task.spawn
	로컬 지연 = 작업 지연

	로컬 LocalPlayer = Players.LocalPlayer
	로컬 마우스 = LocalPlayer:GetMouse()

	local FromRGB = Color3.fromRGB
	로컬 FromHSV = Color3.fromHSV
	local FromHex = Color3.fromHex

	로컬 RGBSequence = ColorSequence.new
	local RGBSequenceKeypoint = ColorSequenceKeypoint.new
	로컬 NumSequence = NumberSequence.new
	local NumSequenceKeypoint = NumberSequenceKeypoint.new

	로컬 UDim2New = UDim2.new
	로컬 UDimNew = UDim.new
	로컬 UDim2FromOffset = UDim2.fromOffset
	로컬 Vector2New = Vector2.new
	로컬 Vector3New = Vector3.new

	로컬 MathClamp = math.clamp
	로컬 MathFloor = math.floor
	로컬 MathAbs = math.abs
	로컬 MathSin = math.sin

	로컬 TableInsert = 테이블.삽입
	로컬 TableFind = table.find
	local TableRemove = table.remove
	로컬 TableConcat = table.concat
	로컬 TableClone = 테이블.clone
	로컬 TableUnpack = table.unpack

	로컬 StringFormat = 문자열.format
	localStringFind = string.find
	로컬 StringGSub = 문자열.gsub
	localStringLower = string.lower
	localStringLen = string.len

	로컬 InstanceNew = Instance.new

	로컬 RectNew = Rect.new

	로컬 GetUI = gethui 또는 함수()
		로컬 성공, 결과 = pcall(function()
			return game:GetService("CoreGui")
		끝)
		성공 및 결과 또는 nil을 반환합니다.
	끝

	로컬 함수 SafeGetUI()
		로컬 성공, 결과 = pcall(GetUI)

		성공과 결과가 있다면
			결과를 반환합니다
		끝

		return game:GetService("CoreGui")
	끝

	라이브러리 = {
		테마 = {
			["배경"] = FromRGB(15, 12, 16),
			["인라인"] = FromRGB(22, 20, 24),
			["Border"] = FromRGB(41, 37, 45),
			["텍스트"] = FromRGB(255, 255, 255),
			["비활성 텍스트"] = FromRGB(185, 185, 185),
			["액센트"] = FromRGB(232, 186, 248),
			["Element"] = FromRGB(36, 32, 39),
		},

		트윈 = {
			시간 = 0.3,
			스타일 = Enum.EasingStyle.Quad,
			방향 = Enum.EasingDirection.Out
		},

		연결 = { },
		스레드 = { },
		ThemeMap = { },
		ThemeItems = { },

		보유자 = 없음,
		NotifHolder = nil,
		글꼴 = 없음
	}

	라이브러리.__index = 라이브러리

	로컬 트윈 = { } do
		트윈.__인덱스 = 트윈

		Tween.Create = function(self, Item, Info, Goal, IsRawItem)
			Item = IsRawItem 및 Item 또는 Item.Instance
			Info = Info 또는 TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

			로컬 NewTween = {
				Tween = TweenService:Create(Item, Info, Goal),
				정보 = 정보,
				목표 = 목표,
				항목 = 항목
			}

			NewTween.Tween:Play()
			setmetatable(NewTween, Tween)

			NewTween을 반환합니다.
		끝

		트윈.겟 = 함수(self)
			self.Tween이 아니면
				반품
			끝
			self.Tween, self.Info, self.Goal을 반환합니다.
		끝

		트윈.일시정지 = 함수(self)
			self.Tween이면
				self.Tween:Pause()
			끝
		끝

		트윈.플레이 = 함수(self)
			self.Tween이면
				self.Tween:Play()
			끝
		끝

		트윈.클린 = 함수(self)
			self.Tween이면
				트윈:일시정지()
			끝
			self = nil
		끝
	끝

	로컬 인스턴스 = { } do
		인스턴스.__인덱스 = 인스턴스

		인스턴스 생성 = 함수(self, 클래스, 속성)
			로컬 성공, 결과 = pcall(function()
				로컬 NewItem = {
					인스턴스 = 인스턴스New(클래스),
					속성 = 속성,
					클래스 = 클래스
				}

				setmetable(NewItem, Instances)

				NewItem.Properties의 속성, 값은 다음과 같습니다.
					pcall(함수()
						NewItem.Instance[Property] = 값
					끝)
				끝

				NewItem을 반환합니다.
			끝)

			성공과 결과가 있다면
				결과를 반환합니다
			끝

			반품 {
				인스턴스 = nil,
				속성 = 속성 또는 {},
				클래스 = 클래스,
				_보호됨 = true
			}
		끝

		Instances.AddToTheme = function(self, Properties)
			self.Instance가 아니면
				반품
			끝

			라이브러리:AddToTheme(self, Properties)

			자신을 반환
		끝

		Instances.Connect = function(self, Event, Callback)
			self.Instance가 아니거나 self.Instance[Event]가 아니면
				반품
			끝

			라이브러리 연결(self.Instance[Event], 콜백)을 반환합니다.
		끝

		Instances.Tween = function(self, Info, Goal)
			self.Instance가 아니면
				반품
			끝

			Tween:Create(self, Info, Goal)을 반환합니다.
		끝

		인스턴스.클린 = 함수(self)
			self.Instance인 경우
				self.Instance:Destroy()
			끝

			self = nil
		끝

		Instances.MakeDraggable = function(self)
			self.Instance가 아니면
				반품
			끝

			로컬 GUI = self.Instance
			로컬 드래깅 = false
			로컬 드래그스타트
			로컬 시작 위치
			로컬 변경됨

			self:Connect("InputBegan", function(Input)
				Input.UserInputType이 Enum.UserInputType.MouseButton1이거나 Input.UserInputType이 Enum.UserInputType.Touch인 경우
					드래그 = true
					DragStart = Input.Position
					시작 위치 = GUI.위치

					변경되었다면
						반품
					끝

					변경됨 = 입력.변경됨:연결(함수())
						Input.UserInputState가 Enum.UserInputState.End와 같으면
							드래그 = false
							변경되었다면
								변경됨: 연결 해제()
								변경됨 = 없음
							끝
						끝
					끝)
				끝
			끝)

			UserInputService.InputChanged:Connect(function(Input)
				입력 유형이 Enum.UserInputType.MouseMovement이거나 입력 유형이 Enum.UserInputType.Touch이고 드래그 중인 경우

					로컬 스케일 = UIScale 및 UIScale.Scale 또는 1
					로컬 드래그델타 = (입력 위치 - 드래그 시작) / 스케일

					self:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						위치 = UDim2New(
							시작 위치.X.스케일,
							StartPosition.X.Offset + DragDelta.X,
							시작 위치.Y.스케일,
							StartPosition.Y.Offset + DragDelta.Y
						)
					})
				끝
			끝)

			드래그하여 반환
		끝
	끝

	로컬 CustomFont = { } do
		함수 CustomFont:New(이름, 두께, 스타일, 데이터)
			isfile(Data.Id)가 아니면
				writefile(Data.Id, game:HttpGet(Data.Url))
			끝

			로컬 AssetSuccess, AssetId = pcall(getcustomasset, Data.Id)
			AssetSuccess가 아니라면
				Font.fromEnum(Enum.Font.Gotham)을 반환합니다.
			끝

			로컬 폰트데이터 = {
				이름 = 이름,
				얼굴 = {
					{
						이름 = 이름,
						무게 = 무게,
						스타일 = 스타일,
						assetId = AssetId
					}
				}
			}

			로컬 글꼴 경로 = Folder_Configs.Assets .. "/" .. 이름 .. ".font"
			만약 isfile(FontPath)가 아니라면
				writefile(FontPath, HttpService:JSONEncode(FontData))
			끝

			로컬 FontAssetSuccess, FontAssetId = pcall(getcustomasset, FontPath)
			FontAssetSuccess가 아니면
				Font.fromEnum(Enum.Font.Gotham)을 반환합니다.
			끝

			Font.new(FontAssetId)를 반환합니다.
		끝

		local FontSuccess = pcall(function()
			Library.Font = CustomFont:New("InterSemibold", 400, "Regular", {
				ID = "InterSemibold",
				URL = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/InterSemibold.ttf"
			})
		끝)

		FontSuccess가 아니면
			라이브러리.폰트 = 폰트.fromEnum(Enum.폰트.Gotham)
		끝
	끝

	Library.Holder = Instances:Create("ScreenGui", {
		부모 = SafeGetUI(),
		이름 = "\0",
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		표시 순서 = 2,
		ResetOnSpawn = false
	})

	기다리다()

	Library.NotifHolder = Instances:Create("Frame", {
		부모 = 라이브러리.홀더.인스턴스,
		이름 = "\0",
		크기 = UDim2New(0, 0, 1, 0),
		위치 = UDim2New(1, 0, 0, 0),
		AnchorPoint = Vector2New(1, 0),
		BackgroundColor3 = FromRGB(0, 0, 0),
		배경 투명도 = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.X
	})

	라이브러리.NotifLayoutOrder = 0

	인스턴스: 생성("UIListLayout", {
		부모 = Library.NotifHolder.Instance,
		이름 = "\0",
		정렬 순서 = Enum.SortOrder.LayoutOrder,
		수평 정렬 = Enum.HorizontalAlignment.오른쪽,
		패딩 = UDimNew(0, 20)
	})

	인스턴스: 생성("UIPadding", {
		부모 = Library.NotifHolder.Instance,
		이름 = "\0",
		PaddingLeft = UDimNew(0, 12),
		PaddingRight = UDimNew(0, 12),
		PaddingTop = UDimNew(0, 12),
		PaddingBottom = UDimNew(0, 12)
	})

	라이브러리.스레드 = 함수(self, 함수)
		로컬 새 스레드 = 코루틴.create(함수)

		코루틴.랩(함수()
			코루틴.재개(새 스레드)
		끝)()

		TableInsert(self.Threads, NewThread)

		새 스레드를 반환합니다.
	끝

	라이브러리.Connect = 함수(self, 이벤트, 콜백)
		로컬 NewConnection = {
			이벤트 = 이벤트,
			콜백 = 콜백,
			이름 = StringFormat("conn_%s", HttpService:GenerateGUID(false)),
			연결 = 없음
		}

		라이브러리.스레드(self, function())
			NewConnection.Connection = Event:Connect(콜백)
		끝)

		테이블 삽입(self.Connections, NewConnection)
		NewConnection을 반환합니다.
	끝

	라이브러리.AddToTheme = function(self, Item, Properties)
		항목 = 항목.인스턴스 또는 항목

		로컬 테마데이터 = {
			항목 = 항목,
			속성 = 속성,
		}

		ThemeData.Properties의 속성 및 값에 대해
			type(Value)가 "string"인 경우
				항목[속성] = self.테마[값] 또는 값
			그렇지 않고 type(Value)가 "function"인 경우
				항목[속성] = 값()
			끝
		끝

		TableInsert(self.ThemeItems, ThemeData)

		self.ThemeMap[Item] = ThemeData
	끝

	로컬 함수 ToTime(a)
		만약 그렇지 않다면
			"키 없음"을 반환합니다.
		그렇지 않고 a가 0보다 작으면
			"평생"을 반환하세요
		끝

		현지 일수 = MathFloor(a / 86400)
		현지 시간 = MathFloor((a % 86400) / 3600)
		현지 분 = MathFloor((a % 3600) / 60)
		로컬 초 = a % 60

		일수가 0보다 크면
			"%dd %dh %dm %ds", 일, 시, 분, 초를 문자열 형식으로 반환합니다.
		그렇지 않고 시간이 0보다 크면
			"%dh %dm %ds", 시간, 분, 초를 문자열 형식으로 반환합니다.
		그렇지 않고 분 > 0이면
			"%dm %ds", 분, 초를 문자열 형식으로 반환합니다.
		또 다른
			"%ds", 초를 문자열 형식으로 반환합니다.
		끝
	끝

	로컬 함수 GetTextSize(텍스트, 너비)
		로컬 성공, 결과 = pcall(function()
			TextService:GetTextSize(Text, 14, Library.Font, Vector2New(Width, 10000))를 반환합니다.
		끝)

		성공이 아니거나 결과가 아니면
			결과 = TextService:GetTextSize(Text, 14, Enum.Font.SourceSans, Vector2New(Width, 10000))
		끝

		결과를 반환합니다
	끝

	라이브러리.알림 = 함수(self, 데이터)
		기다리다()
		Library.NotifLayoutOrder = (Library.NotifLayoutOrder 또는 0) + 1

		local TitleText = Data.Title 또는 Data.Name 또는 ""
		local DescText = Data.Description 또는 ""
		로컬 지속 시간 = Data.Duration 또는 5

		로컬 패딩H = 6
		로컬 PaddingV = 5
		로컬 갭 = 5
		로컬 BarGap = 4
		로컬 BarH = 3
		로컬 최대 너비 = 330

		로컬 함수 GetTextSize(텍스트, 글꼴 크기, 너비)
			로컬 글꼴 = 라이브러리.글꼴

			글꼴 유형이 "EnumItem"과 같거나 글꼴 유형이 Enum.Font와 같으면
				글꼴 = Enum.Font.Gotham
			끝

			너비가 0 이하이면
				너비 = 10000
			끝

			TextService:GetTextSize(Text, FontSize, Font, Vector2.new(Width, 10000))를 반환합니다.
		끝

		local TitleSize = GetTextSize(TitleText, 14, MaxWidth)
		local DescAvailableWidth = MaxWidth - PaddingH * 2
		local DescSize = DescText ~= "" 및 GetTextSize(DescText, 12, DescAvailableWidth) 또는 Vector2.new(DescAvailableWidth, 28)

		local TitleH = math.max(math.ceil(math.max(TitleSize.Y, 1)), 15)
		로컬 DescH = math.max(math.ceil(math.max(DescSize.Y, 1)), 14)

		DescH < 28이면 DescH = 28 end

		local ContentWidth = math.max(math.ceil(math.max(TitleSize.X, 1)), math.ceil(math.max(DescSize.X, 1)), 100)
		ContentWidth = math.min(math.max(ContentWidth + PaddingH * 2, 100), MaxWidth)

		로컬 SizeY = PaddingV + TitleH + Gap + DescH + BarGap + BarH + PaddingV

		로컬 항목 = {} do
			Items["Notification"] = Instances:Create("Frame", {
				부모 = Library.NotifHolder.Instance,
				이름 = "\0",
				BackgroundColor3 = Library.Theme["Background"],
				배경 투명도 = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				레이아웃 순서 = 라이브러리.NotifLayoutOrder,
				크기 = UDim2New(0, ContentWidth, 0, SizeY)
			}):AddToTheme({BackgroundColor3 = 'Background'})

			인스턴스: 생성("UICorner", {
				부모 = Items["알림"].인스턴스,
				이름 = "\0",
				코너반경 = UDimNew(0, 5)
			})

			인스턴스: 생성("UIPadding", {
				부모 = Items["알림"].인스턴스,
				이름 = "\0",
				PaddingLeft = UDimNew(0, PaddingH),
				PaddingRight = UDimNew(0, PaddingH),
				PaddingTop = UDimNew(0, PaddingV),
				PaddingBottom = UDimNew(0, PaddingV)
			})

			Items["Title"] = Instances:Create("TextLabel", {
				부모 = Items["알림"].인스턴스,
				이름 = "\0",
				크기 = UDim2New(1, 0, 0, TitleH),
				배경 투명도 = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				텍스트 = 제목텍스트,
				TextColor3 = Library.Theme["Text"],
				텍스트 크기 = 14,
				FontFace = Library.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				텍스트 줄 바꿈 = true,
				텍스트투명도 = 1
			}):AddToTheme({TextColor3 = '텍스트'})

			Items["Description"] = Instances:Create("TextLabel", {
				부모 = Items["알림"].인스턴스,
				이름 = "\0",
				크기 = UDim2New(1, -PaddingH * 2, 0, DescH),
				위치 = UDim2New(0, PaddingH, 0, TitleH + Gap),
				배경 투명도 = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				텍스트 = 설명텍스트,
				TextColor3 = Library.Theme["Text"],
				텍스트 크기 = 12,
				FontFace = Library.Font,
				텍스트투명도 = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				텍스트 줄 바꿈 = true,
				TextTruncate = Enum.TextTruncate.None,
				RichText = false,
				TextScaled = false,
				AutomaticSize = Enum.AutomaticSize.Y
			}):AddToTheme({TextColor3 = '텍스트'})

			인스턴스 생성("UITextSizeConstraint", {
				부모 = Items["Description"].인스턴스,
				이름 = "\0",
				최소텍스트크기 = 12,
				최대텍스트크기 = 12
			})

			Items["Duration"] = Instances:Create("Frame", {
				부모 = Items["알림"].인스턴스,
				이름 = "\0",
				크기 = UDim2New(1, 0, 0, BarH),
				위치 = UDim2New(0, 0, 0, TitleH + Gap + DescH + BarGap),
				BackgroundColor3 = Library.Theme["Inline"],
				배경 투명도 = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0
			}):AddToTheme({BackgroundColor3 = '인라인'})

			인스턴스: 생성("UICorner", {
				부모 = Items["Duration"].Instance,
				이름 = "\0",
				코너반경 = UDimNew(0, 5)
			})

			Items["Accent"] = Instances:Create("Frame", {
				부모 = Items["Duration"].Instance,
				이름 = "\0",
				크기 = UDim2New(1, 0, 1, 0),
				BackgroundColor3 = Data.Color,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0
			})

			인스턴스: 생성("UICorner", {
				부모 = Items["Accent"].Instance,
				이름 = "\0",
				코너반경 = UDimNew(0, 5)
			})
		끝

		local FadeInfo = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)
		local BarInfo = TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

		로컬 프레임 = { Items["알림"], Items["지속 시간"] }
		로컬 텍스트 레이블 = { 항목["제목"] }
		로컬 DescLabel = Items["설명"]

		라이브러리: 스레드(함수())
			_의 경우, 프레임의 항목은 다음과 같습니다.
				항목:Tween(FadeInfo, {BackgroundTransparency = 0})
			끝

			_, TextLabels의 항목에 대해 다음을 수행합니다.
				항목:Tween(FadeInfo, {TextTransparency = 0})
			끝

			DescLabel:Tween(FadeInfo, {TextTransparency = 0.4})

			Items["알림"]:Tween(FadeInfo, {Size = UDim2New(0, ContentWidth, 0, SizeY)})
			Items["Accent"]:Tween(BarInfo, {Size = UDim2New(0, 0, 1, 0)})

			지연(Duration + 0.1, function())
				_의 경우, 프레임의 항목은 다음과 같습니다.
					항목:Tween(FadeInfo, {BackgroundTransparency = 1})
				끝

				_, TextLabels의 항목에 대해 다음을 수행합니다.
					항목:Tween(FadeInfo, {TextTransparency = 1})
				끝

				DescLabel:Tween(FadeInfo, {TextTransparency = 1})

				Items["알림"]:Tween(FadeInfo, {Size = UDim2New(0, 0, 0, SizeY)})
				대기(0.5)
				항목["알림"]:Clean()
			끝)
		끝)
	끝

	local BlurEffect = Instances:Create("BlurEffect", {
		이름 = "\0",
		크기 = 0,
		부모 = 조명
	})

	로컬 항목 = { } do
		Items["ScreenGui"] = Instances:Create("ScreenGui", {
			부모 = SafeGetUI(),
			이름 = "\0",
			ZIndexBehavior = Enum.ZIndexBehavior.Global,
			표시 순서 = 999,
			ResetOnSpawn = false,
			IgnoreGuiInset = true
		})

		Items["Overlay"] = Instances:Create("Frame", {
			부모 = Items["ScreenGui"].Instance,
			이름 = "\0",
			크기 = UDim2New(1, 0, 1, 0),
			BackgroundColor3 = FromRGB(0, 0, 0),
			배경 투명도 = 1,
			BorderSizePixel = 0,
			ZIndex = 1
		})

		Items["MainFrame"] = Instances:Create("Frame", {
			부모 = Items["ScreenGui"].Instance,
			이름 = "\0",
			크기 = UDim2New(0, 0, 0, 0),
			위치 = UDim2New(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2New(0.5, 0.5),
			BackgroundColor3 = Library.Theme["Background"],
			배경 투명도 = 0.15,
			BorderSizePixel = 0,
			ZIndex = 2
		}):AddToTheme({BackgroundColor3 = 'Background'})

		인스턴스: 생성("UICorner", {
			부모 = Items["MainFrame"].Instance,
			이름 = "\0",
			코너반경 = UDimNew(0, 8)
		})

		Items["MainStroke"] = Instances:Create("UIStroke", {
			부모 = Items["MainFrame"].Instance,
			이름 = "\0",
			색상 = Library.Theme["Border"],
			두께 = 1,
			투명도 = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		}):AddToTheme({Color = 'Border'})

		Items["TitleLabel"] = Instances:Create("TextLabel", {
			부모 = Items["MainFrame"].Instance,
			이름 = "\0",
			크기 = UDim2New(1, 0, 0, 40),
			위치 = UDim2New(0, 0, 0, 20),
			배경 투명도 = 1,
			BorderSizePixel = 0,
			텍스트 = 구성 제목,
			TextColor3 = Library.Theme["Accent"],
			텍스트 크기 = 28,
			FontFace = Library.Font,
			텍스트투명도 = 1,
			ZIndex = 2
		}):AddToTheme({TextColor3 = '악센트'})

		Items["SubtitleLabel"] = Instances:Create("TextLabel", {
			부모 = Items["MainFrame"].Instance,
			이름 = "\0",
			크기 = UDim2New(1, 0, 0, 20),
			위치 = UDim2New(0, 0, 0, 65),
			배경 투명도 = 1,
			BorderSizePixel = 0,
			텍스트 = 구성 설명,
			TextColor3 = Library.Theme["비활성 텍스트"],
			텍스트 크기 = 13,
			FontFace = Library.Font,
			텍스트투명도 = 1,
			ZIndex = 2
		}):AddToTheme({TextColor3 = '비활성 텍스트'})

		Items["Line"] = Instances:Create("Frame", {
			부모 = Items["MainFrame"].Instance,
			이름 = "\0",
			크기 = UDim2New(0.84, 0, 0, 1),
			위치 = UDim2New(0.08, 0, 0, 95),
			BackgroundColor3 = Library.Theme["Border"],
			배경 투명도 = 1,
			BorderSizePixel = 0,
			ZIndex = 2
		}):AddToTheme({BackgroundColor3 = 'Border'})

		Items["TextBoxContainer"] = Instances:Create("Frame", {
			부모 = Items["MainFrame"].Instance,
			이름 = "\0",
			크기 = UDim2New(0, 480, 0, 50),
			위치 = UDim2New(0.5, 0, 0, 115),
			AnchorPoint = Vector2New(0.5, 0),
			BackgroundColor3 = Library.Theme["Element"],
			배경 투명도 = 1,
			BorderSizePixel = 0,
			ZIndex = 2
		}):AddToTheme({BackgroundColor3 = 'Element'})

		인스턴스: 생성("UICorner", {
			부모 = Items["TextBoxContainer"].Instance,
			이름 = "\0",
			코너반경 = UDimNew(0, 5)
		})

		인스턴스: 생성("UIGradient", {
			부모 = Items["TextBoxContainer"].Instance,
			이름 = "\0",
			회전 = 90도,
			색상 = RGBSequence({
				RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
				RGBSequenceKeypoint(1, FromRGB(216, 216, 216))
			})
		})

		Items["TextBoxStroke"] = Instances:Create("UIStroke", {
			부모 = Items["TextBoxContainer"].Instance,
			이름 = "\0",
			색상 = Library.Theme["Border"],
			두께 = 1,
			투명도 = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		}):AddToTheme({Color = 'Border'})

		Items["KeyTextBox"] = Instances:Create("TextBox", {
			부모 = Items["TextBoxContainer"].Instance,
			이름 = "\0",
			크기 = UDim2New(1, -24, 1, 0),
			위치 = UDim2New(0, 12, 0, 0),
			배경 투명도 = 1,
			BorderSizePixel = 0,
			ZIndex = 2,
			텍스트 = "",
			TextColor3 = Library.Theme["Text"],
			텍스트 크기 = 15,
			FontFace = Library.Font,
			PlaceholderText = "여기에 키를 붙여넣으세요...",
			PlaceholderColor3 = Library.Theme["비활성 텍스트"],
			TextXAlignment = Enum.TextXAlignment.Left,
			텍스트투명도 = 1,
			커서 위치 = -1,
			ClearTextOnFocus = false
		}):AddToTheme({TextColor3 = '텍스트', PlaceholderColor3 = '비활성 텍스트'})

		Items["CloseButton"] = Instances:Create("TextButton", {
			부모 = Items["MainFrame"].Instance,
			이름 = "\0",
			크기 = UDim2New(0, 30, 0, 30),
			위치 = UDim2New(1, -40, 0, 10),
			BackgroundColor3 = Library.Theme["Element"],
			배경 투명도 = 1,
			BorderSizePixel = 0,
			텍스트 = "X",
			TextColor3 = Library.Theme["Text"],
			텍스트 크기 = 18,
			FontFace = Library.Font,
			AutoButtonColor = false,
			텍스트투명도 = 1,
			ZIndex = 2
		}):AddToTheme({BackgroundColor3 = 'Element', TextColor3 = 'Text'})

		인스턴스: 생성("UICorner", {
			부모 = Items["CloseButton"].Instance,
			이름 = "\0",
			코너반경 = UDimNew(0, 5)
		})

		Items["CloseStroke"] = Instances:Create("UIStroke", {
			부모 = Items["CloseButton"].Instance,
			이름 = "\0",
			색상 = Library.Theme["Border"],
			두께 = 1,
			투명도 = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		}):AddToTheme({Color = 'Border'})
	끝

	로컬 버튼 = { }

	로컬 함수 CreateButton(Text, Position)
		로컬 버튼 = 인스턴스:Create("텍스트 버튼", {
			부모 = Items["MainFrame"].Instance,
			이름 = "\0",
			크기 = UDim2New(0, 220, 0, 45),
			위치 = 위치,
			AnchorPoint = Vector2New(0.5, 0),
			BackgroundColor3 = Library.Theme["Element"],
			배경 투명도 = 1,
			BorderSizePixel = 0,
			텍스트 = 텍스트,
			TextColor3 = Library.Theme["Text"],
			TextSize = IsMobile이고 13 또는 15인 경우,
			FontFace = Library.Font,
			AutoButtonColor = false,
			텍스트투명도 = 1,
			ZIndex = 2
		}):AddToTheme({BackgroundColor3 = 'Element', TextColor3 = 'Text'})

		인스턴스: 생성("UICorner", {
			부모 = Button.Instance,
			이름 = "\0",
			코너반경 = UDimNew(0, 5)
		})

		인스턴스: 생성("UIGradient", {
			부모 = Button.Instance,
			이름 = "\0",
			회전 = 90도,
			색상 = RGBSequence({
				RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
				RGBSequenceKeypoint(1, FromRGB(216, 216, 216))
			})
		})

		Items["ButtonStroke"] = Instances:Create("UIStroke", {
			부모 = Button.Instance,
			이름 = "\0",
			색상 = Library.Theme["Border"],
			두께 = 1,
			투명도 = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		}):AddToTheme({Color = 'Border'})

		TableInsert(Buttons, {Button = Button, Stroke = Items["ButtonStroke"]})
		돌아가기 버튼
	끝

	IsMobile이면
		Items["Button1"] = CreateButton("키 가져오기(Linkvertise)", UDim2New(0.5, 0, 0, 185))
		Items["Button2"] = CreateButton("키 가져오기(Rinku)", UDim2New(0.5, 0, 0, 240))
		Items["Button3"] = CreateButton("Discord 가입", UDim2New(0.5, 0, 0, 295))
		Items["Button4"] = CreateButton("표준 키 구매", UDim2New(0.5, 0, 0, 350))

		_의 경우, 버튼의 버튼은 다음과 같습니다.
			Button.Button.Instance.Size = UDim2New(0, 320, 0, 42)
		끝
	또 다른
		Items["Button1"] = CreateButton("키 가져오기(Linkvertise)", UDim2New(0.25, 0, 0, 190))
		Items["Button2"] = CreateButton("키 가져오기(Rinku)", UDim2New(0.75, 0, 0, 190))
		Items["Button3"] = CreateButton("Discord에 참여", UDim2New(0.25, 0, 0, 255))
		Items["Button4"] = CreateButton("표준 키 구매", UDim2New(0.75, 0, 0, 255))
	끝

	local TweenData = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	로컬 함수 CloseUI()
		BlurEffect:Tween(TweenData, {Size = 0})
		Items["Overlay"]:Tween(TweenData, {BackgroundTransparency = 1})

		Items["TitleLabel"]:Tween(TweenData, {TextTransparency = 1})
		Items["SubtitleLabel"]:Tween(TweenData, {TextTransparency = 1})
		Items["Line"]:Tween(TweenData, {BackgroundTransparency = 1})
		Items["TextBoxContainer"]:Tween(TweenData, {BackgroundTransparency = 1})
		Items["TextBoxStroke"]:Tween(TweenData, {Transparency = 1})
		Items["KeyTextBox"]:Tween(TweenData, {TextTransparency = 1})
		Items["CloseButton"]:Tween(TweenData, {BackgroundTransparency = 1, TextTransparency = 1})
		Items["CloseStroke"]:Tween(TweenData, {Transparency = 1})
		Items["MainStroke"]:Tween(TweenData, {Transparency = 1})

		_의 경우, 버튼의 버튼은 다음과 같습니다.
			Button.Button:Tween(TweenData, {BackgroundTransparency = 1, TextTransparency = 1})
			Button.Stroke:Tween(TweenData, {Transparency = 1})
		끝

		Items["MainFrame"]:Tween(TweenData, {Size = UDim2New(0, 0, 0, 0)})
		대기(0.35)
		BlurEffect:Clean()
		Items["ScreenGui"]:Clean()
	끝

	로컬 함수 ValidateKey(Key)
		local CleanedKey = Key:gsub("%s", "")

		만약 문자열이 CleanedKey와 "^[A-Za-z0-9]+$"가 일치하지 않거나 #CleanedKey가 32와 거의 같지 않다면
			라이브러리:알림({
				제목 = "솔릭스 허브",
				설명 = "잘못된 키 형식입니다. 키는 32자여야 합니다."
				Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
				소요 시간 = 5
			})
			false를 반환합니다.
		끝

		CleanedKey가 Key와 거의 같으면
			라이브러리:알림({
				제목 = "솔릭스 허브",
				설명 = "추가 공백이 감지되었습니다. 공백 없이 확인합니다..."
				Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
				소요 시간 = 5
			})
		끝

		로컬 성공, 결과 = pcall(LuarmorApi.check_key, CleanedKey)

		성공하지 못하면
			라이브러리:알림({
				제목 = "솔릭스 허브",
				설명 = "네트워크 오류입니다. 다시 시도해 주세요."
				Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
				소요 시간 = 5
			})
			false를 반환합니다.
		끝

		Result.code가 "KEY_VALID"와 같으면
			script_key = CleanedKey

			Config.File이 아닌 경우
				pcall(writefile, Config.File, CleanedKey)
			그렇지 않고 readfile(Config.File)이 CleanedKey와 같으면
				pcall(writefile, Config.File, CleanedKey)
			끝

			getgenv().key = CleanedKey
			getgenv().luarmor_api = LuarmorApi
			getgenv().key_expire = Result.data 및 Result.data.auth_expire 또는 0
			getgenv().key_note = Result.data 및 Result.data.note 또는 ""
			getgenv().key_executions = Result.data 및 Result.data.total_executions 또는 0

			라이브러리:알림({
				제목 = "솔릭스 허브",
				설명 = "키 만료 시간: " .. ToTime(getgenv().key_expire - os.time()),
				Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
				소요 시간 = 5
			})

			대기(1.5)
			CloseUI()

			그렇지 않다면 (
				GameId == "3808223175" -- Jujutsu Infinite
					또는 GameId == "994732206" -- Blox Fruits
					또는 GameId == "1511883870" -- 신도 라이프
					또는 GameId == "7018190066" -- 데드 레일즈
					또는 GameId == "7671049560" -- 더 포지
					또는 GameId == "9363735110" -- 뇌를 썩게 만드는 쓰나미 탈출!
					또는 GameId == "5130394318" -- 기묘한 계보
					또는 GameId == "9186719164" -- 세일러 피스
					또는 GameId == "9787206684" -- 행운의 블록이 되어 보세요
					또는 GameId == "9875383684" -- 뇌를 썩게 만들지 마세요
					또는 GameId == "4658598196" -- 진격의 거인 레볼루션
				) 그리고 getgenv().lilix가 아닙니다.
				라이브러리:알림({
					제목 = "솔릭스 허브",
					설명 = "이 실행기는 이 게임에서 지원되지 않습니다."
					Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
					소요 시간 = 5
				})
			끝

			pcall(함수()
				LuarmorApi.load_script()
			끝)

			true를 반환합니다.
		끝

		파일 삭제(Config.File)

		ErrorMessages[Result.code]이면
			Result.code가 "SECURITY_ERROR"이거나 Result.code가 "UNKNOWN_ERROR"인 경우
				라이브러리:알림({
					제목 = "솔릭스 허브",
					설명 = ErrorMessages[Result.code],
					Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
					소요 시간 = 5
				})
			또 다른
				라이브러리:알림({
					제목 = "솔릭스 허브",
					설명 = ErrorMessages[Result.code],
					Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
					소요 시간 = 5
				})
			끝
			false를 반환합니다.
		끝

		라이브러리:알림({
			제목 = "솔릭스 허브",
			설명 = "키 확인 실패:\n코드: " .. 결과 코드,
			Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
			소요 시간 = 5
		})
		false를 반환합니다.
	끝

	_의 경우, 버튼의 버튼은 다음과 같습니다.
		Button.Button:Connect("MouseEnter", function()
			Button.Button:Tween(TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = IsMobile and UDim2New(0, 330, 0, 45) or UDim2New(0, 230, 0, 48)})
		끝)
		Button.Button:Connect("MouseLeave", function()
			Button.Button:Tween(TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = IsMobile and UDim2New(0, 320, 0, 42) or UDim2New(0, 220, 0, 45)})
		끝)
		Button.Button:Connect("MouseButton1Down", function()
			Button.Button:Tween(TweenInfo.new(0.08), {Size = IsMobile 및 UDim2New(0, 310, 0, 40) 또는 UDim2New(0, 210, 0, 42)})
		끝)
		Button.Button:Connect("MouseButton1Up", function()
			Button.Button:Tween(TweenInfo.new(0.08), {Size = IsMobile 및 UDim2New(0, 320, 0, 42) 또는 UDim2New(0, 220, 0, 45)})
		끝)
	끝

	Items["Button1"]:Connect("MouseButton1Click", function()
		만약 setclipboard라면
			setclipboard(Config.Linkvertise)
		끝
		라이브러리:알림({
			제목 = "솔릭스 허브",
			설명 = "Linkvertise 링크가 클립보드에 복사되었습니다."
			Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
			소요 시간 = 5
		})
	끝)

	Items["Button2"]:Connect("MouseButton1Click", function()
		만약 setclipboard라면
			setclipboard(Config.Rinku)
		끝
		라이브러리:알림({
			제목 = "솔릭스 허브",
			설명 = "Rinku 링크가 클립보드에 복사되었습니다",
			Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
			소요 시간 = 5
		})
	끝)

	Items["Button3"]:Connect("MouseButton1Click", function()
		만약 setclipboard라면
			setclipboard(Config.Discord)
		끝
		라이브러리:알림({
			제목 = "솔릭스 허브",
			설명 = "Discord 초대 링크가 클립보드에 복사되었습니다",
			Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
			소요 시간 = 5
		})
	끝)

	Items["Button4"]:Connect("MouseButton1Click", function()
		만약 setclipboard라면
			setclipboard(Config.Shop)
		끝
		라이브러리:알림({
			제목 = "솔릭스 허브",
			설명 = "표준 키샵 링크가 복사되었습니다",
			Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
			소요 시간 = 5
		})
	끝)

	Items["KeyTextBox"]:Connect("FocusLost", function()
		Items["KeyTextBox"].Instance.Text == ""이면
			반품
		끝

		ValidateKey(Items["KeyTextBox"].Instance.Text)가 아니면
			Items["KeyTextBox"].Instance.Text = ""
		끝
	끝)

	Items["CloseButton"]:Connect("MouseButton1Click", function()
		CloseUI()
	끝)

	Items["CloseButton"]:Connect("MouseEnter", function()
		Items["CloseButton"]:Tween(TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2New(0, 35, 0, 35)})
	끝)

	Items["CloseButton"]:Connect("MouseLeave", function()
		Items["CloseButton"]:Tween(TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2New(0, 30, 0, 30)})
	끝)

	Items["MainFrame"]:MakeDraggable()

	local UIScale = InstanceNew("UIScale")
	UIScale.Scale = 1
	UIScale.Parent = Items["ScreenGui"].Instance

	로컬 함수 GetViewportSize()
		로컬 카메라 = Workspace.CurrentCamera
		카메라와 카메라의 뷰포트 크기를 반환하거나 Vector2.new(1920, 1080)을 반환합니다.
	끝

	로컬 함수 SetMobileScale()
		로컬 뷰포트 = GetViewportSize()

		IsMobile이면
			로컬 스케일 = MathClamp(Viewport.Y / 500, 0.5, 1.5)
			UIScale.Scale = 스케일
		또 다른
			UIScale.Scale = 1
		끝
	끝

	IsMobile이면
		Items["MainFrame"].Instance.Size = UDim2New(0, 380, 0, 440)
		Items["TitleLabel"].Instance.TextSize = 22
		Items["SubtitleLabel"].Instance.TextSize = 10
		Items["TextBoxContainer"].Instance.Size = UDim2New(0, 340, 0, 45)
		SetMobileScale()
	끝

	local FinalSize = IsMobile 및 UDim2New(0, 380, 0, 440) 또는 UDim2New(0, 580, 0, 340)
	local TweenInfo2 = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

	BlurEffect:Tween(TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 24})
	Items["Overlay"]:Tween(TweenInfo.new(0.3), {BackgroundTransparency = 0.3})
	Items["MainFrame"]:Tween(TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = FinalSize})

	대기(0.3)

	Items["TitleLabel"]:Tween(TweenInfo2, {TextTransparency = 0})
	Items["SubtitleLabel"]:Tween(TweenInfo2, {TextTransparency = 0})
	Items["Line"]:Tween(TweenInfo2, {BackgroundTransparency = 0})
	Items["TextBoxContainer"]:Tween(TweenInfo2, {BackgroundTransparency = 0})
	Items["TextBoxStroke"]:Tween(TweenInfo2, {Transparency = 0})
	Items["KeyTextBox"]:Tween(TweenInfo2, {TextTransparency = 0})
	Items["CloseButton"]:Tween(TweenInfo2, {BackgroundTransparency = 0, TextTransparency = 0})
	Items["CloseStroke"]:Tween(TweenInfo2, {Transparency = 0})
	Items["MainStroke"]:Tween(TweenInfo2, {Transparency = 0})

	_의 경우, 버튼의 버튼은 다음과 같습니다.
		Button.Button:Tween(TweenInfo2, {BackgroundTransparency = 0, TextTransparency = 0})
		Button.Stroke:Tween(TweenInfo2, {Transparency = 0})
	끝

	생성(함수())
		while wait(0.3) do
			local SavedKey = (isfile(Config.File) and readfile(Config.File)) or (script_key ~= "" and script_key) or nil

			SavedKey와 ValidateKey(SavedKey)가 모두 성립하면
				반품
			끝
		끝
	끝)
끝

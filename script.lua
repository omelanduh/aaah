              _____   _   _   ______      ____    _   _     _______    ____    _____  
     /\      / ____| | \ | | |  ____|    / __ \  | \ | |   |__   __|  / __ \  |  __ \ 
    /  \    | |      |  \| | | |__      | |  | | |  \| |      | |    | |  | | | |__) |
   / /\ \   | |      | . ` | |  __|     | |  | | | . ` |      | |    | |  | | |  ___/ 
  / ____ \  | |____  | |\  | | |____    | |__| | | |\  |      | |    | |__| | | |     
 /_/    \_\  \_____| |_| \_| |______|    \____/  |_| \_|      |_|     \____/  |_|     
                                                                                      
                                                                                      
local v0=string.char;local v1=string.byte;local v2=string.sub;local v3=bit32 or bit ;local v4=v3.bxor;local v5=table.concat;local v6=table.insert;local function v7(v59,v60) local v61={};for v275=1, #v59 do v6(v61,v0(v4(v1(v2(v59,v275,v275 + 1 )),v1(v2(v60,1 + (v275% #v60) ,1 + (v275% #v60) + 1 )))%256 ));end return v5(v61);end local v8=game:GetService(v7("\225\207\218\60\227\169\212","\126\177\163\187\69\134\219\167"));local v9=v8.LocalPlayer;local v10=game:GetService(v7("\20\194\56\206\239\51\204\41\192","\156\67\173\74\165")).CurrentCamera;local v11=game:GetService(v7("\6\162\71\37\185\52\80\61\180\76","\38\84\215\41\118\220\70"));local v12=game:GetService(v7("\101\5\39\0\215\94\6\55\6\205\85\4\52\27\253\85","\158\48\118\66\114"));local v13=game:GetService(v7("\159\51\21\51\125\150\254\185\50\25\53\118","\155\203\68\112\86\19\197"));local v14=false;local v15=false;local v16=false;local v17=false;local v18=true;local v19=1182 -(396 + 736) ;local v20=nil;local v21=v7("\110\200\59\253\78\119\236\252\116\210\57\232\112\121\247\236","\152\38\189\86\156\32\24\133");local v22=15 + 1 ;local v23=false;local v24=50 + 0 ;local v25=Drawing.new(v7("\223\94\181\69\240\82","\38\156\55\199"));v25.Visible=false;v25.Color=Color3.fromRGB(255,0 + 0 ,0 + 0 );v25.Thickness=2 + 0 ;v25.Transparency=2 -1 ;v25.Filled=false;v25.Radius=v24;v25.Position=Vector2.new(v10.ViewportSize.X/(5 -3) ,v10.ViewportSize.Y/(4 -2) );local v33={[v7("\141\78\76\13\29\117\248\79\173\121","\35\200\29\28\72\115\20\154")]=false,[v7("\58\190\220\243\130\47\63\60\177\208\221\129\41\48","\84\121\223\177\191\237\76")]=false,[v7("\136\70\204\165\62\117\62\192\185\90\204\164","\161\219\54\169\192\90\48\80")]=false,[v7("\122\82\5\32\77\116\1\41\92\71","\69\41\34\96")]=16,[v7("\145\194\207\38\13\40\183\231\222\25\22\42\178\192\210","\75\220\163\183\106\98")]=15 + 35 ,[v7("\46\181\136\60\251\13\190\146\7\216\16\174","\185\98\218\235\87")]=v7("\227\41\42\231\208\165\194\56\21\233\209\190\251\61\53\242","\202\171\92\71\134\190"),[v7("\14\244\5\190\32\210\37\138\37\196","\232\73\161\76")]=true,[v7("\136\208\78\88\16\175\248\75\80\59\181\216\64\81\27\191","\126\219\185\34\61")]=false,[v7("\63\199\82\119\112\99\210\238\1\232\113\68","\135\108\174\62\18\30\23\147")]=241 -191 };local v34=Instance.new(v7("\158\224\45\195\20\167\52\207\162","\167\214\137\74\171\120\206\83"));v34.FillColor=Color3.fromRGB(881 -(239 + 514) ,0 + 0 ,1457 -(797 + 532) );v34.FillTransparency=0.5 + 0 ;v34.OutlineColor=Color3.fromRGB(87 + 168 ,599 -344 ,1457 -(373 + 829) );v34.OutlineTransparency=0;v34.Parent=nil;local v40={[v7("\169\255\42\98\219\168\135\255\32","\199\235\144\82\61\152")]=Color3.fromRGB(986 -(476 + 255) ,0,1130 -(369 + 761) ),[v7("\37\25\161\20\51\30\176\40\12\24\188\56\20","\75\103\118\217")]=1 + 0 ,[v7("\239\81\113\24\173\22\229\85\98","\126\167\52\16\116\217")]=true};local v41,v42,v43,v44,v45,v46,v47,v48,v49,v50;local function v51() v41=Instance.new(v7("\251\45\50\133\177\23\219\221\39","\156\168\78\64\224\212\121"));v41.Parent=v9:WaitForChild(v7("\55\226\164\215\2\252\130\219\14","\174\103\142\197"));v42=Instance.new(v7("\112\58\94\53\32","\152\54\72\63\88\69\62"));v42.Size=UDim2.new(0 -0 ,300,0 -0 ,588 -(64 + 174) );v42.Position=UDim2.new(0.1 + 0 ,0 -0 ,336.1 -(144 + 192) ,0);v42.BackgroundColor3=Color3.fromRGB(236 -(42 + 174) ,16 + 4 ,17 + 3 );v42.BorderSizePixel=0 + 0 ;v42.BorderColor3=Color3.fromRGB(1632 -(363 + 1141) ,0,1708 -(1183 + 397) );v42.Visible=v33.GUIVisible;v42.Parent=v41;v42.BackgroundTransparency=0.1;local v72=Instance.new(v7("\225\237\205\83\198\202\235\78","\60\180\164\142"));v72.CornerRadius=UDim.new(0 -0 ,9 + 3 );v72.Parent=v42;local v75=Instance.new(v7("\108\91\29\61\11\236\16\93\82","\114\56\62\101\73\71\141"));v75.Size=UDim2.new(0,75 + 25 ,0,20);v75.Position=UDim2.new(1975 -(1913 + 62) ,10,1, -(19 + 11));v75.BackgroundTransparency=2 -1 ;v75.Text=v7("\153\202\245\225","\164\216\137\187");v75.TextColor3=Color3.fromRGB(255,2188 -(565 + 1368) ,958 -703 );v75.TextTransparency=1661.5 -(1477 + 184) ;v75.TextSize=18 -4 ;v75.Font=Enum.Font.SourceSans;v75.TextXAlignment=Enum.TextXAlignment.Left;v75.Parent=v42;local v88=false;local v89,v90,v91;local function v92(v276) local v277=v276.Position-v90 ;local v278=UDim2.new(v91.X.Scale,v91.X.Offset + v277.X ,v91.Y.Scale,v91.Y.Offset + v277.Y );local v279=TweenInfo.new(0.2 + 0 ,Enum.EasingStyle.Quad,Enum.EasingDirection.Out);local v280=v13:Create(v42,v279,{[v7("\226\233\34\187\178\247\4\220","\107\178\134\81\210\198\158")]=v278});v280:Play();end v42.InputBegan:Connect(function(v281) if ((v281.UserInputType==Enum.UserInputType.MouseButton1) or (v281.UserInputType==Enum.UserInputType.Touch)) then local v304=0;while true do if (v304==(856 -(564 + 292))) then v88=true;v90=v281.Position;v304=1 -0 ;end if (v304==1) then v91=v42.Position;v281.Changed:Connect(function() if (v281.UserInputState==Enum.UserInputState.End) then v88=false;end end);break;end end end end);v42.InputChanged:Connect(function(v282) if ((v282.UserInputType==Enum.UserInputType.MouseMovement) or (v282.UserInputType==Enum.UserInputType.Touch)) then v89=v282;end end);v12.InputChanged:Connect(function(v283) if ((v283==v89) and v88) then v92(v283);end end);local function v93(v284,v285) local v286=0 -0 ;local v287;local v288;local v289;while true do if (v286==(305 -(244 + 60))) then v289=v13:Create(v284,v288,{[v7("\26\15\129\205\173\42\1\151\200\174\27\1\142\201\184\107","\202\88\110\226\166")]=v287});v289:Play();break;end if (v286==0) then v287=(v285 and Color3.fromRGB(39 + 11 ,476 -(41 + 435) ,50)) or Color3.fromRGB(1081 -(938 + 63) ,0 + 0 ,80) ;v288=TweenInfo.new(1125.3 -(936 + 189) ,Enum.EasingStyle.Quad,Enum.EasingDirection.Out);v286=1 + 0 ;end end end v43=Instance.new(v7("\247\10\154\227\232\214\27\150\248\196","\170\163\111\226\151"));v43.Size=UDim2.new(1613 -(1565 + 48) ,30,0 + 0 ,30);v43.Position=UDim2.new(1138 -(782 + 356) ,10,267 -(176 + 91) ,26 -16 );v43.BackgroundColor3=(v33.ESPEnabled and Color3.fromRGB(50,0 -0 ,1142 -(975 + 117) )) or Color3.fromRGB(1955 -(157 + 1718) ,0 + 0 ,283 -203 ) ;v43.TextColor3=Color3.fromRGB(871 -616 ,1273 -(697 + 321) ,694 -439 );v43.Text="";v43.TextSize=50 -26 ;v43.Font=Enum.Font.SourceSansBold;v43.AutoButtonColor=false;v43.Parent=v42;local v104=Instance.new(v7("\36\25\145\55\92\57\44\3","\73\113\80\210\88\46\87"));v104.CornerRadius=UDim.new(0 -0 ,8);v104.Parent=v43;local v107=Instance.new(v7("\181\41\213\6\203\128\46\200\30","\135\225\76\173\114"));v107.Size=UDim2.new(0 + 0 ,187 -87 ,0 -0 ,1257 -(322 + 905) );v107.Position=UDim2.new(611 -(602 + 9) ,50,0,10);v107.BackgroundTransparency=1190 -(449 + 740) ;v107.Text=v7("\63\222\136","\199\122\141\216\208\204\221");v107.TextColor3=Color3.fromRGB(1127 -(826 + 46) ,255,1202 -(245 + 702) );v107.TextSize=56 -38 ;v107.Font=Enum.Font.SourceSansBold;v107.Parent=v42;v44=Instance.new(v7("\153\216\8\228\90\227\185\201\31\254","\150\205\189\112\144\24"));v44.Size=UDim2.new(0 + 0 ,1928 -(260 + 1638) ,0,470 -(382 + 58) );v44.Position=UDim2.new(0 -0 ,10,0 + 0 ,103 -53 );v44.BackgroundColor3=(v33.CamLockEnabled and Color3.fromRGB(148 -98 ,0,50)) or Color3.fromRGB(1285 -(902 + 303) ,0,80) ;v44.TextColor3=Color3.fromRGB(255,559 -304 ,255);v44.Text="";v44.TextSize=57 -33 ;v44.Font=Enum.Font.SourceSansBold;v44.AutoButtonColor=false;v44.Parent=v42;local v125=Instance.new(v7("\16\173\156\67\22\134\20\2","\112\69\228\223\44\100\232\113"));v125.CornerRadius=UDim.new(0 + 0 ,8);v125.Parent=v44;local v128=Instance.new(v7("\224\26\31\199\154\125\132\209\19","\230\180\127\103\179\214\28"));v128.Size=UDim2.new(1690 -(1121 + 569) ,314 -(22 + 192) ,0,30);v128.Position=UDim2.new(683 -(483 + 200) ,50,1463 -(1404 + 59) ,136 -86 );v128.BackgroundTransparency=1 -0 ;v128.Text=v7("\175\4\82\74\235\66\235\193\49","\128\236\101\63\38\132\33");v128.TextColor3=Color3.fromRGB(1020 -(468 + 297) ,255,817 -(334 + 228) );v128.TextSize=18;v128.Font=Enum.Font.SourceSansBold;v128.Parent=v42;v45=Instance.new(v7("\152\172\9\80\148\228\215","\175\204\201\113\36\214\139"));v45.Size=UDim2.new(0,150,0,101 -71 );v45.Position=UDim2.new(0 -0 ,10,0 -0 ,26 + 64 );v45.BackgroundColor3=Color3.fromRGB(296 -(141 + 95) ,59 + 1 ,154 -94 );v45.TextColor3=Color3.fromRGB(612 -357 ,60 + 195 ,698 -443 );v45.Text=tostring(v33.MaxLockDistance);v45.TextSize=18;v45.Font=Enum.Font.SourceSansBold;v45.PlaceholderText=v7("\106\205\45\156\32\78\223\33\221\10\68\201\117\148\81\23\129\96\140\84\14","\100\39\172\85\188");v45.Parent=v42;local v146=Instance.new(v7("\152\81\154\143\33\163\125\171","\83\205\24\217\224"));v146.CornerRadius=UDim.new(0 + 0 ,8);v146.Parent=v45;v46=Instance.new(v7("\210\192\213\41\196\208\217\41\233\203","\93\134\165\173"));v46.Size=UDim2.new(0,79 + 71 ,0,42 -12 );v46.Position=UDim2.new(0,6 + 4 ,163 -(92 + 71) ,130);v46.BackgroundColor3=Color3.fromRGB(40 + 40 ,0 -0 ,80);v46.TextColor3=Color3.fromRGB(255,1020 -(574 + 191) ,255);v46.Text=v7("\156\253\197\219\10\207\160\106\228\178","\30\222\146\161\162\90\174\210")   .. (((v33.LockBodyPart==v7("\205\91\125\11\235\65\121\14\215\65\127\30\213\79\98\30","\106\133\46\16")) and v7("\108\47\97\239\85","\32\56\64\19\156\58")) or v7("\114\205\228\82","\224\58\168\133\54\58\146")) ;v46.TextSize=15 + 3 ;v46.Font=Enum.Font.SourceSansBold;v46.Parent=v42;local v157=Instance.new(v7("\108\127\104\242\103\136\130\25","\107\57\54\43\157\21\230\231"));v157.CornerRadius=UDim.new(0,19 -11 );v157.Parent=v46;v47=Instance.new(v7("\239\142\9\225\155\201\219\207\132\31","\175\187\235\113\149\217\188"));v47.Size=UDim2.new(0 + 0 ,30,849 -(254 + 595) ,156 -(55 + 71) );v47.Position=UDim2.new(0,13 -3 ,1790 -(573 + 1217) ,470 -300 );v47.BackgroundColor3=(v33.SpeedEnabled and Color3.fromRGB(50,0 + 0 ,50)) or Color3.fromRGB(128 -48 ,939 -(714 + 225) ,233 -153 ) ;v47.TextColor3=Color3.fromRGB(355 -100 ,255,28 + 227 );v47.Text="";v47.TextSize=34 -10 ;v47.Font=Enum.Font.SourceSansBold;v47.AutoButtonColor=false;v47.Parent=v42;local v169=Instance.new(v7("\9\134\162\67\241\119\125\46","\24\92\207\225\44\131\25"));v169.CornerRadius=UDim.new(806 -(118 + 688) ,56 -(25 + 23) );v169.Parent=v47;local v172=Instance.new(v7("\127\214\160\88\55\124\73\214\180","\29\43\179\216\44\123"));v172.Size=UDim2.new(0 + 0 ,100,1886 -(927 + 959) ,30);v172.Position=UDim2.new(0 -0 ,782 -(16 + 716) ,0 -0 ,267 -(11 + 86) );v172.BackgroundTransparency=2 -1 ;v172.Text=v7("\142\201\37\73\185\148\3","\44\221\185\64");v172.TextColor3=Color3.fromRGB(255,255,255);v172.TextSize=303 -(175 + 110) ;v172.Font=Enum.Font.SourceSansBold;v172.Parent=v42;v48=Instance.new(v7("\53\226\80\75\81\14\255","\19\97\135\40\63"));v48.Size=UDim2.new(0,378 -228 ,0,30);v48.Position=UDim2.new(0,49 -39 ,0,2006 -(503 + 1293) );v48.BackgroundColor3=Color3.fromRGB(167 -107 ,60,44 + 16 );v48.TextColor3=Color3.fromRGB(255,1316 -(810 + 251) ,255);v48.Text=tostring(v33.SpeedValue);v48.TextSize=18;v48.Font=Enum.Font.SourceSansBold;v48.PlaceholderText=v7("\157\76\54\62\43\113\230\13\101\118\126\97\254\21","\81\206\60\83\91\79");v48.Parent=v42;local v190=Instance.new(v7("\123\130\243\125\61\205\72\182","\196\46\203\176\18\79\163\45"));v190.CornerRadius=UDim.new(0 + 0 ,8);v190.Parent=v48;v49=Instance.new(v7("\140\39\102\10\6\238\251\172\45\112","\143\216\66\30\126\68\155"));v49.Size=UDim2.new(0,30,0 + 0 ,28 + 2 );v49.Position=UDim2.new(533 -(43 + 490) ,10,733 -(711 + 22) ,250);v49.BackgroundColor3=(v33.SilentAimEnabled and Color3.fromRGB(50,0 -0 ,50)) or Color3.fromRGB(939 -(240 + 619) ,0,80) ;v49.TextColor3=Color3.fromRGB(255,62 + 193 ,405 -150 );v49.Text="";v49.TextSize=2 + 22 ;v49.Font=Enum.Font.SourceSansBold;v49.AutoButtonColor=false;v49.Parent=v42;local v202=Instance.new(v7("\159\225\46\196\215\173\210\243","\129\202\168\109\171\165\195\183"));v202.CornerRadius=UDim.new(1744 -(1344 + 400) ,8);v202.Parent=v49;local v205=Instance.new(v7("\22\93\47\204\242\21\228\39\84","\134\66\56\87\184\190\116"));v205.Size=UDim2.new(0,100,405 -(255 + 150) ,24 + 6 );v205.Position=UDim2.new(0 + 0 ,213 -163 ,0 -0 ,1989 -(404 + 1335) );v205.BackgroundTransparency=407 -(183 + 223) ;v205.Text=v7("\8\48\27\188\28\255\97\20\53\60","\85\92\81\105\219\121\139\65");v205.TextColor3=Color3.fromRGB(310 -55 ,255,169 + 86 );v205.TextSize=18;v205.Font=Enum.Font.SourceSansBold;v205.Parent=v42;v50=Instance.new(v7("\201\182\72\81\94\208\229","\191\157\211\48\37\28"));v50.Size=UDim2.new(0,150,0,11 + 19 );v50.Position=UDim2.new(0,10,0,290);v50.BackgroundColor3=Color3.fromRGB(397 -(10 + 327) ,42 + 18 ,60);v50.TextColor3=Color3.fromRGB(593 -(118 + 220) ,85 + 170 ,704 -(108 + 341) );v50.Text=tostring(v33.SilentAimFOV);v50.TextSize=9 + 9 ;v50.Font=Enum.Font.SourceSansBold;v50.PlaceholderText=v7("\249\48\194\92\8\222\27\253\9\41\159\87\165\76\119\141\79\164\85","\90\191\127\148\124");v50.Parent=v42;local v223=Instance.new(v7("\77\174\13\24\106\137\43\5","\119\24\231\78"));v223.CornerRadius=UDim.new(0 -0 ,1501 -(711 + 782) );v223.Parent=v50;v43.MouseButton1Click:Connect(function() local v290=0 -0 ;while true do if (v290==(470 -(270 + 199))) then v93(v43,v14);for v336,v337 in pairs(v8:GetPlayers()) do if (v337~=v9) then coroutine.wrap(ESP)(v337);end end break;end if (v290==(0 + 0)) then v14= not v14;v33.ESPEnabled=v14;v290=1820 -(580 + 1239) ;end end end);v44.MouseButton1Click:Connect(function() local v291=0 -0 ;while true do if (1==v291) then v93(v44,v15);break;end if (v291==(0 + 0)) then v15= not v15;v33.CamLockEnabled=v15;v291=1;end end end);v47.MouseButton1Click:Connect(function() local v292=0 + 0 ;while true do if (v292==(0 + 0)) then v16= not v16;v33.SpeedEnabled=v16;v292=2 -1 ;end if (v292==(1 + 0)) then v93(v47,v16);break;end end end);v49.MouseButton1Click:Connect(function() local v293=1167 -(645 + 522) ;while true do if (v293==1) then v93(v49,v23);v25.Visible=v23;break;end if (v293==0) then v23= not v23;v33.SilentAimEnabled=v23;v293=1791 -(1010 + 780) ;end end end);v50.FocusLost:Connect(function(v294) if v294 then local v305=0;local v306;while true do if (v305==(0 + 0)) then v306=tonumber(v50.Text);if (v306 and (v306>=(47 -37)) and (v306<=(586 -386))) then local v362=1836 -(1045 + 791) ;while true do if (1==v362) then v25.Radius=v306;break;end if (v362==0) then v24=v306;v33.SilentAimFOV=v306;v362=2 -1 ;end end else v50.Text=tostring(v24);end break;end end end end);v46.MouseButton1Click:Connect(function() if (v21==v7("\170\56\168\75\210\79\24\134\31\170\69\200\112\16\144\57","\113\226\77\197\42\188\32")) then local v307=0;while true do if (v307==0) then v21=v7("\18\19\245\177","\213\90\118\148");v46.Text=v7("\121\33\176\79\125\90\60\160\12\13\115\43\181\82","\45\59\78\212\54");break;end end else local v308=0 -0 ;while true do if (v308==(505 -(351 + 154))) then v21=v7("\56\67\142\138\136\33\164\244\34\89\140\159\182\47\191\228","\144\112\54\227\235\230\78\205");v46.Text=v7("\145\39\11\229\224\90\161\60\85\188\228\84\161\59\0","\59\211\72\111\156\176");break;end end end v33.LockBodyPart=v21;end);v45.FocusLost:Connect(function(v296) if v296 then local v309=1574 -(1281 + 293) ;local v310;while true do if (v309==(266 -(28 + 238))) then v310=tonumber(v45.Text);if (v310 and (v310>=50) and (v310<=(1117 -617))) then local v364=1559 -(1381 + 178) ;local v365;while true do if (0==v364) then v365=0 + 0 ;while true do if (v365==0) then v19=v310;v33.MaxLockDistance=v19;break;end end break;end end else v45.Text=tostring(v19);end break;end end end end);v48.FocusLost:Connect(function(v297) if v297 then local v311=0;local v312;while true do if (v311==(0 + 0)) then v312=tonumber(v48.Text);if (v312 and (v312>=(7 + 9)) and (v312<=(344 -244))) then v22=v312;v33.SpeedValue=v22;else v48.Text=tostring(v22);end break;end end end end);end v12.InputBegan:Connect(function(v226,v227) local v228=0 + 0 ;local v229;while true do if (v228==(470 -(381 + 89))) then v229=0;while true do if (0==v229) then if v227 then return;end if (v226.KeyCode==Enum.KeyCode.Insert) then v33.GUIVisible= not v33.GUIVisible;v42.Visible=v33.GUIVisible;end break;end end break;end end end);v9.CharacterAdded:Connect(function() local v230=0;while true do if (v230==(1 + 0)) then v51();break;end if ((0 + 0)==v230) then wait(1 -0 );if v41 then v41:Destroy();end v230=1157 -(1074 + 82) ;end end end);v51();local function v52(v231) local v232={[v7("\64\134\238\40","\77\46\231\131")]=Drawing.new(v7("\142\81\174\84","\32\218\52\214")),[v7("\70\18\48\164\229\184\71\91\92","\58\46\119\81\200\145\208\37")]=Drawing.new(v7("\7\133\62\169","\86\75\236\80\204\201\221")),[v7("\117\83\114\128\240\131\119\64\123\145\246","\235\18\33\23\229\158")]=Drawing.new(v7("\124\179\207\190","\219\48\218\161"))};v232.name.Visible=v14;v232.name.Color=v40.Box_Color;v232.name.Size=39 -21 ;v232.name.Center=true;v232.name.Outline=true;v232.name.OutlineColor=Color3.new(1784 -(214 + 1570) ,0,1455 -(990 + 465) );v232.name.Text=v231.Name;v232.healthbar.Visible=v14;v232.healthbar.Color=Color3.fromRGB(106 + 149 ,0 + 0 ,0);v232.healthbar.Thickness=2 + 0 ;v232.greenhealth.Visible=v14;v232.greenhealth.Color=Color3.fromRGB(0 -0 ,255,1726 -(1668 + 58) );v232.greenhealth.Thickness=628 -(512 + 114) ;local function v248() local v298;v298=v11.RenderStepped:Connect(function() if (v231.Character and v231.Character:FindFirstChild(v7("\204\100\113\72\213\64\233\224","\128\132\17\28\41\187\47")) and v231.Character:FindFirstChild(v7("\41\39\11\59\83\14\59\2\8\82\14\38\54\59\79\21","\61\97\82\102\90"))) then local v326=v231.Character.HumanoidRootPart;local v327,v328=v10:WorldToViewportPoint(v326.Position);if v328 then v232.name.Position=Vector2.new(v327.X,v327.Y-30 );v232.name.Visible=v14;local v344=v231.Character.Humanoid.Health;local v345=v231.Character.Humanoid.MaxHealth;local v346=v344/v345 ;local v347=50;local v348=Vector2.new(v327.X-(v347/(5 -3)) ,v327.Y + 20 );v232.healthbar.From=v348;v232.healthbar.To=Vector2.new(v348.X + v347 ,v348.Y);v232.healthbar.Visible=v14;v232.greenhealth.From=v348;v232.greenhealth.To=Vector2.new(v348.X + (v347 * v346) ,v348.Y);v232.greenhealth.Visible=v14;else v232.name.Visible=false;v232.healthbar.Visible=false;v232.greenhealth.Visible=false;end else local v329=0 -0 ;while true do if ((0 -0)==v329) then v232.name.Visible=false;v232.healthbar.Visible=false;v329=1 + 0 ;end if (v329==(1 + 0)) then v232.greenhealth.Visible=false;if  not v8:FindFirstChild(v231.Name) then v298:Disconnect();end break;end end end end);end coroutine.wrap(v248)();end for v249,v250 in pairs(v8:GetPlayers()) do if (v250~=v9) then coroutine.wrap(v52)(v250);end end v8.PlayerAdded:Connect(function(v251) if (v251~=v9) then coroutine.wrap(v52)(v251);end end);v8.PlayerAdded:Connect(function(v252) if (v252~=v9) then OnCharacterAdded(v252);end end);local function v53() local v253=nil;local v254=math.huge;local v255=v9:GetMouse();local v256=Vector2.new(v255.X,v255.Y);for v299,v300 in pairs(v8:GetPlayers()) do if ((v300~=v9) and v300.Character and v300.Character:FindFirstChild(v21)) then local v313=0 + 0 ;local v314;local v315;local v316;while true do if (v313==(0 -0)) then v314=0;v315=nil;v313=1;end if (v313==(1995 -(109 + 1885))) then v316=nil;while true do if (v314==0) then v315=v300.Character;v316=(v9.Character.HumanoidRootPart.Position-v315.HumanoidRootPart.Position).Magnitude;v314=1470 -(1269 + 200) ;end if ((1 -0)==v314) then if (v316<=v19) then local v388=815 -(98 + 717) ;local v389;local v390;while true do if (v388==0) then v389,v390=v10:WorldToViewportPoint(v315[v21].Position);if v390 then local v396=0;local v397;local v398;while true do if (v396==(827 -(802 + 24))) then if (v398<v254) then local v404=0;while true do if (v404==(0 -0)) then v254=v398;v253=v300;break;end end end break;end if (v396==(0 -0)) then local v403=0 + 0 ;while true do if (v403==0) then v397=Vector2.new(v389.X,v389.Y);v398=(v256-v397).Magnitude;v403=1;end if (1==v403) then v396=1 + 0 ;break;end end end end end break;end end end break;end end break;end end end end return v253;end v12.InputBegan:Connect(function(v257,v258) local v259=0 + 0 ;local v260;while true do if (v259==0) then v260=0 + 0 ;while true do if (v260==(0 -0)) then if v258 then return;end if ((v257.KeyCode==Enum.KeyCode.T) and v15) then if v20 then local v382=0 -0 ;while true do if ((0 + 0)==v382) then v34.Parent=nil;v20=nil;break;end end else local v383=0;local v384;while true do if (v383==0) then v384=0;while true do if (v384==0) then v20=v53();if (v20 and v20.Character) then v34.Parent=v20.Character;end break;end end break;end end end end break;end end break;end end end);v11.RenderStepped:Connect(function() if (v15 and v20 and v20.Character and v20.Character:FindFirstChild(v21)) then local v303=v20.Character:FindFirstChild(v7("\132\59\166\74\201\88\23\13","\105\204\78\203\43\167\55\126"));if (v303 and (v303.Health>(0 + 0))) then local v330=v20.Character[v21].Position;v10.CFrame=CFrame.new(v10.CFrame.Position,v330);else local v332=0 + 0 ;local v333;while true do if (v332==(0 + 0)) then v333=0;while true do if (v333==(0 + 0)) then v34.Parent=nil;v20=nil;break;end end break;end end end end end);local function v54() if (v16 and v9.Character and v9.Character:FindFirstChild(v7("\141\191\46\31\29\11\206\85","\49\197\202\67\126\115\100\167"))) then if v17 then v9.Character.Humanoid.WalkSpeed=v22;else v9.Character.Humanoid.WalkSpeed=1449 -(797 + 636) ;end end end v12.InputBegan:Connect(function(v261,v262) local v263=0 -0 ;local v264;while true do if (v263==0) then v264=0;while true do if (v264==0) then if v262 then return;end if ((v261.KeyCode==Enum.KeyCode.C) and v16) then local v371=1619 -(1427 + 192) ;local v372;while true do if (v371==(0 + 0)) then v372=0;while true do if ((0 -0)==v372) then v17= not v17;v54();break;end end break;end end end break;end end break;end end end);v11.RenderStepped:Connect(function() if v16 then v54();end end);local function v55() local v265=nil;local v266=math.huge;local v267=v9:GetMouse();local v268=Vector2.new(v267.X,v267.Y);for v301,v302 in pairs(v8:GetPlayers()) do if ((v302~=v9) and v302.Character and v302.Character:FindFirstChild(v7("\31\78\210\40\142\89\87\51\105\208\38\148\102\95\37\79","\62\87\59\191\73\224\54"))) then local v317=0;local v318;local v319;local v320;while true do if (v317==(0 + 0)) then local v358=0;while true do if ((0 + 0)==v358) then v318=v302.Character;v319,v320=v10:WorldToViewportPoint(v318.HumanoidRootPart.Position);v358=327 -(192 + 134) ;end if (v358==(1277 -(316 + 960))) then v317=1 + 0 ;break;end end end if (v317==(1 + 0)) then if v320 then local v373=0 + 0 ;local v374;local v375;local v376;while true do if (v373==(3 -2)) then v376=nil;while true do if (v374==(551 -(83 + 468))) then v375=Vector2.new(v319.X,v319.Y);v376=(v268-v375).Magnitude;v374=1807 -(1202 + 604) ;end if (v374==1) then if ((v376<v266) and (v376<=v24)) then local v399=0 -0 ;while true do if (v399==(0 -0)) then v266=v376;v265=v302;break;end end end break;end end break;end if (v373==(0 -0)) then v374=0;v375=nil;v373=326 -(45 + 280) ;end end end break;end end end end return v265;end local v56=game:GetService(v7("\213\7\234\197\238\1\251\221\226\6\201\221\232\16\251\206\226","\169\135\98\154")):WaitForChild(v7("\232\118\42\121\252\48\218\196\69\33\89\242\39\205","\168\171\23\68\52\157\83"));local v57=v56.FireServer;v56.FireServer=function(...) local v269=0 + 0 ;local v270;while true do if (v269==0) then v270=0;while true do if (v270==(0 + 0)) then if v23 then local v377=0;local v378;while true do if (v377==(0 + 0)) then v378=v55();if v378 then local v392=0 + 0 ;local v393;while true do if (v392==(0 + 0)) then v393=v378.Character.HumanoidRootPart.Position;v57(v56,v393);v392=1 -0 ;end if (v392==(1912 -(340 + 1571))) then return;end end end break;end end end v57(v56,...);break;end end break;end end end;v11.RenderStepped:Connect(function() local v271=v9:GetMouse();v25.Position=Vector2.new(v271.X,v271.Y);v25.Radius=v24;v25.Visible=v23;end);

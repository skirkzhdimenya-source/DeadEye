[8550.240811] ==================================================
[8550.241959] DeadEye Legit AutoJump Test v1.16
[8550.242007] GROUND AUTOJUMP = ENABLED
[8550.242021] GROUND TRIGGER = DataRegistry.Grounded ONLY
[8550.242032] LANDED DOES NOT TRIGGER JUMP
[8550.242043] ONE GROUND JUMP UNTIL GROUNDED BECOMES FALSE
[8550.242052] NATURAL CLIMBING PRESERVED
[8550.242060] CLIMBING GETS ONE ORIGINAL JumpReact(false)
[8550.242069] ALL ORIGINAL JumpReact / AttemptJump CHECKS
[8550.242079] ONLY EndClimb BLOCKED WHILE CLIMBING
[8550.242087] NO PARALLEL JumpReact()
[8550.242095] F7 = ON/OFF
[8550.242103] F6 = FULL STOP + COPY LOG
[8550.242110] ==================================================
[8550.242121] READY
[8551.476099] ===== F7 -> AUTO JUMP ON =====
[8551.476254] LIVE Movement hooked successfully
[8551.476321] F7 INITIAL STATE | Hum=Enum.HumanoidStateType.Running | Move=Idle | Reg=Idle | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=0.000312
[8551.477826] >>> GROUND AUTO JUMP #1 | Hum=Enum.HumanoidStateType.Running
[8551.477867] ==================================================
[8551.477885] ORIGINAL JumpReact | REASON=GROUND
[8551.477909] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Idle | Reg=Idle | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=0.000312
[8551.477986] Humanoid.Jump = true
[8551.478217] >>> AUTO RELEASE | JumpHeldDown=false
[8551.478261] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy 0.000312 -> 0.000312 | DeltaVy=0.000000 | CanJump=true | JumpHeld=false
[8551.478284] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Idle | Reg=Idle | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=0.000312
[8551.491975] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112177 | CanJump=true | JumpHeld=false | HumJump=false
[8551.508702] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8552.118275] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.346143 | CanJump=true | JumpHeld=false | HumJump=false
[8552.169681] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-17.054478 | CanJump=true | JumpHeld=false | HumJump=false
[8552.186604] >>> GROUND AUTO JUMP #2 | Hum=Enum.HumanoidStateType.Running
[8552.186663] ==================================================
[8552.186681] ORIGINAL JumpReact | REASON=GROUND
[8552.186705] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Idle | Reg=Idle | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.054478
[8552.186726] Humanoid.Jump = true
[8552.187007] >>> AUTO RELEASE | JumpHeldDown=false
[8552.187050] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -17.054478 -> -1.975327 | DeltaVy=15.079150 | CanJump=true | JumpHeld=false
[8552.187084] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Idle | Reg=Idle | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-1.975327
[8552.196872] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112177 | CanJump=true | JumpHeld=false | HumJump=false
[8552.218744] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8552.558062] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-3.873262 | CanJump=true | JumpHeld=false | HumJump=false
[8552.607828] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-8.854458 | CanJump=true | JumpHeld=false | HumJump=false
[8552.635760] >>> GROUND AUTO JUMP #3 | Hum=Enum.HumanoidStateType.Running
[8552.635837] ==================================================
[8552.635858] ORIGINAL JumpReact | REASON=GROUND
[8552.635877] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-9.271124
[8552.635926] Humanoid.Jump = true
[8552.636888] >>> AUTO RELEASE | JumpHeldDown=false
[8552.636929] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -9.271124 -> -10.312789 | DeltaVy=-1.041665 | CanJump=true | JumpHeld=false
[8552.636951] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-10.312789
[8552.645260] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.320509 | CanJump=true | JumpHeld=false | HumJump=false
[8552.666963] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8553.329994] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-16.846146 | CanJump=true | JumpHeld=false | HumJump=false
[8553.364513] >>> GROUND AUTO JUMP #4 | Hum=Enum.HumanoidStateType.Landed
[8553.364654] ==================================================
[8553.364685] ORIGINAL JumpReact | REASON=GROUND
[8553.364713] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-18.096149
[8553.364751] Humanoid.Jump = true
[8553.365287] >>> AUTO RELEASE | JumpHeldDown=false
[8553.365347] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -18.096149 -> -18.721151 | DeltaVy=-0.625002 | CanJump=true | JumpHeld=false
[8553.365373] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-18.721151
[8553.372795] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112179 | CanJump=true | JumpHeld=false | HumJump=false
[8553.403879] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8553.954644] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-11.846145 | CanJump=true | JumpHeld=false | HumJump=false
[8554.005191] >>> GROUND AUTO JUMP #5 | Hum=Enum.HumanoidStateType.Running
[8554.005254] ==================================================
[8554.005270] ORIGINAL JumpReact | REASON=GROUND
[8554.005293] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-13.929475
[8554.005333] Humanoid.Jump = true
[8554.005675] >>> AUTO RELEASE | JumpHeldDown=false
[8554.005700] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -13.929475 -> -14.346141 | DeltaVy=-0.416666 | CanJump=true | JumpHeld=false
[8554.005717] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-14.346141
[8554.005736] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-14.346141 | CanJump=true | JumpHeld=false | HumJump=true
[8554.021019] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8554.912514] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-27.679512 | CanJump=true | JumpHeld=false | HumJump=false
[8554.939343] >>> GROUND AUTO JUMP #6 | Hum=Enum.HumanoidStateType.Landed
[8554.939435] ==================================================
[8554.939468] ORIGINAL JumpReact | REASON=GROUND
[8554.939497] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-28.512848
[8554.939529] Humanoid.Jump = true
[8554.940010] >>> AUTO RELEASE | JumpHeldDown=false
[8554.940068] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -28.512848 -> -14.530560 | DeltaVy=13.982288 | CanJump=true | JumpHeld=false
[8554.940141] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-14.530560
[8554.947850] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112175 | CanJump=true | JumpHeld=false | HumJump=false
[8554.987394] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8555.548207] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-12.887814 | CanJump=true | JumpHeld=false | HumJump=false
[8555.598374] >>> GROUND AUTO JUMP #7 | Hum=Enum.HumanoidStateType.Running
[8555.598453] ==================================================
[8555.598475] ORIGINAL JumpReact | REASON=GROUND
[8555.598501] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-14.971144
[8555.598535] Humanoid.Jump = true
[8555.598767] >>> AUTO RELEASE | JumpHeldDown=false
[8555.598805] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -14.971144 -> -15.387810 | DeltaVy=-0.416666 | CanJump=true | JumpHeld=false
[8555.598824] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-15.387810
[8555.598841] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-15.387810 | CanJump=true | JumpHeld=false | HumJump=true
[8555.614347] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8555.621676] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=false | Vy=16.695507 | CanJump=true | JumpHeld=false | HumJump=false
[8555.963120] >>> GROUND AUTO JUMP #8 | Hum=Enum.HumanoidStateType.Freefall
[8555.963270] ==================================================
[8555.963308] ORIGINAL JumpReact | REASON=GROUND
[8555.963395] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-0.033163
[8555.963501] Humanoid.Jump = true
[8555.963924] >>> AUTO RELEASE | JumpHeldDown=false
[8555.963980] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy -0.033163 -> 0.191835 | DeltaVy=0.224998 | CanJump=true | JumpHeld=false
[8555.964022] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=0.191835
[8555.975092] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=-0.134235 | CanJump=true | JumpHeld=false | HumJump=false
[8556.233347] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8556.321521] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-15.109730 | CanJump=true | JumpHeld=false | HumJump=false
[8556.371530] >>> GROUND AUTO JUMP #9 | Hum=Enum.HumanoidStateType.Running
[8556.371650] ==================================================
[8556.371682] ORIGINAL JumpReact | REASON=GROUND
[8556.371711] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Idle | Reg=Idle | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.192247
[8556.371744] Humanoid.Jump = true
[8556.372133] >>> AUTO RELEASE | JumpHeldDown=false
[8556.372239] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -17.192247 -> -17.608749 | DeltaVy=-0.416502 | CanJump=true | JumpHeld=false
[8556.372277] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Idle | Reg=Idle | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.608749
[8556.372301] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-17.608749 | CanJump=true | JumpHeld=false | HumJump=true
[8556.396316] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=true | Vy=-0.358896 | CanJump=true | JumpHeld=false | HumJump=false
[8556.445943] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=3.554395 | CanJump=true | JumpHeld=false | HumJump=false
[8569.355780] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=-0.416334 | CanJump=false | JumpHeld=true | HumJump=false
[8569.420271] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=0.092662 | CanJump=false | JumpHeld=true | HumJump=false
[8571.013208] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8571.118610] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Freefall | Grounded=false | Vy=3.511739 | CanJump=true | JumpHeld=false | HumJump=false
[8571.845859] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-32.738297 | CanJump=true | JumpHeld=false | HumJump=false
[8571.880295] >>> GROUND AUTO JUMP #10 | Hum=Enum.HumanoidStateType.Landed
[8571.880434] ==================================================
[8571.880508] ORIGINAL JumpReact | REASON=GROUND
[8571.880599] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.988127
[8571.880643] Humanoid.Jump = true
[8571.881131] >>> AUTO RELEASE | JumpHeldDown=false
[8571.881179] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -16.988127 -> -1.236792 | DeltaVy=15.751335 | CanJump=true | JumpHeld=false
[8571.881211] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-1.236792
[8571.890517] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=16.903843 | CanJump=true | JumpHeld=false | HumJump=false
[8571.913127] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8572.518805] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.554476 | CanJump=true | JumpHeld=false | HumJump=false
[8572.569125] >>> GROUND AUTO JUMP #11 | Hum=Enum.HumanoidStateType.Running
[8572.569217] ==================================================
[8572.569249] ORIGINAL JumpReact | REASON=GROUND
[8572.569283] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.637810
[8572.569327] Humanoid.Jump = true
[8572.569741] >>> AUTO RELEASE | JumpHeldDown=false
[8572.569796] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -16.637810 -> -8.540200 | DeltaVy=8.097610 | CanJump=true | JumpHeld=false
[8572.569828] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-8.540200
[8572.569865] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-8.540200 | CanJump=true | JumpHeld=false | HumJump=true
[8572.602183] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8573.218877] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.971142 | CanJump=true | JumpHeld=false | HumJump=false
[8573.269181] >>> GROUND AUTO JUMP #12 | Hum=Enum.HumanoidStateType.Running
[8573.269244] ==================================================
[8573.269261] ORIGINAL JumpReact | REASON=GROUND
[8573.269283] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.846144
[8573.269305] Humanoid.Jump = true
[8573.269747] >>> AUTO RELEASE | JumpHeldDown=false
[8573.269818] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -16.846144 -> -4.832798 | DeltaVy=12.013345 | CanJump=true | JumpHeld=false
[8573.269852] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-4.832798
[8573.269880] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-4.832798 | CanJump=true | JumpHeld=false | HumJump=true
[8573.293535] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=true | Vy=16.278839 | CanJump=true | JumpHeld=false | HumJump=false
[8573.302025] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8573.920494] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.971144 | CanJump=true | JumpHeld=false | HumJump=false
[8573.970850] >>> GROUND AUTO JUMP #13 | Hum=Enum.HumanoidStateType.Running
[8573.970914] ==================================================
[8573.970934] ORIGINAL JumpReact | REASON=GROUND
[8573.970954] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.054480
[8573.970979] Humanoid.Jump = true
[8573.971231] >>> AUTO RELEASE | JumpHeldDown=false
[8573.971259] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -17.054480 -> -8.969791 | DeltaVy=8.084688 | CanJump=true | JumpHeld=false
[8573.971275] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-8.969791
[8573.971291] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-8.969791 | CanJump=true | JumpHeld=false | HumJump=true
[8573.994645] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8574.621673] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.971142 | CanJump=true | JumpHeld=false | HumJump=false
[8574.639048] >>> GROUND AUTO JUMP #14 | Hum=Enum.HumanoidStateType.Landed
[8574.639117] ==================================================
[8574.639135] ORIGINAL JumpReact | REASON=GROUND
[8574.639156] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=3.473095
[8574.639175] Humanoid.Jump = true
[8574.639555] >>> AUTO RELEASE | JumpHeldDown=false
[8574.639595] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy 3.473095 -> 3.056436 | DeltaVy=-0.416659 | CanJump=true | JumpHeld=false
[8574.639614] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=3.056436
[8574.648970] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.111012 | CanJump=true | JumpHeld=false | HumJump=false
[8574.705460] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8575.337451] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-17.264021 | CanJump=true | JumpHeld=false | HumJump=false
[8575.380411] >>> GROUND AUTO JUMP #15 | Hum=Enum.HumanoidStateType.Landed
[8575.380501] ==================================================
[8575.380524] ORIGINAL JumpReact | REASON=GROUND
[8575.380552] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-18.930693
[8575.380583] Humanoid.Jump = true
[8575.381067] >>> AUTO RELEASE | JumpHeldDown=false
[8575.381121] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -18.930693 -> -9.676702 | DeltaVy=9.253990 | CanJump=true | JumpHeld=false
[8575.381150] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-9.676702
[8575.390052] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=16.903843 | CanJump=true | JumpHeld=false | HumJump=false
[8575.403757] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8576.028891] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.971142 | CanJump=true | JumpHeld=false | HumJump=false
[8576.071467] >>> GROUND AUTO JUMP #16 | Hum=Enum.HumanoidStateType.Landed
[8576.071568] ==================================================
[8576.071592] ORIGINAL JumpReact | REASON=GROUND
[8576.071620] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.637810
[8576.071652] Humanoid.Jump = true
[8576.072160] >>> AUTO RELEASE | JumpHeldDown=false
[8576.072195] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -16.637810 -> -17.054478 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8576.072216] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.054478
[8576.081932] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=16.903843 | CanJump=true | JumpHeld=false | HumJump=false
[8576.087786] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8576.719329] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.971142 | CanJump=true | JumpHeld=false | HumJump=false
[8576.761524] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-17.054478 | CanJump=true | JumpHeld=false | HumJump=false
[8576.771067] >>> GROUND AUTO JUMP #17 | Hum=Enum.HumanoidStateType.Running
[8576.771124] ==================================================
[8576.771142] ORIGINAL JumpReact | REASON=GROUND
[8576.771165] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.054478
[8576.771194] Humanoid.Jump = true
[8576.771419] >>> AUTO RELEASE | JumpHeldDown=false
[8576.771453] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -17.054478 -> -11.784986 | DeltaVy=5.269492 | CanJump=true | JumpHeld=false
[8576.771474] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-11.784986
[8576.786270] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=true | Vy=16.695509 | CanJump=true | JumpHeld=false | HumJump=false
[8576.794973] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8577.423003] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-15.179475 | CanJump=true | JumpHeld=false | HumJump=false
[8577.464824] >>> GROUND AUTO JUMP #18 | Hum=Enum.HumanoidStateType.Landed
[8577.464930] ==================================================
[8577.464957] ORIGINAL JumpReact | REASON=GROUND
[8577.464984] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.846144
[8577.465019] Humanoid.Jump = true
[8577.465295] >>> AUTO RELEASE | JumpHeldDown=false
[8577.465397] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -16.846144 -> -17.262812 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8577.465429] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.262812
[8577.474263] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112175 | CanJump=true | JumpHeld=false | HumJump=false
[8577.489637] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8578.130639] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-15.596143 | CanJump=true | JumpHeld=false | HumJump=false
[8578.170954] >>> GROUND AUTO JUMP #19 | Hum=Enum.HumanoidStateType.Landed
[8578.171067] ==================================================
[8578.171098] ORIGINAL JumpReact | REASON=GROUND
[8578.171129] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.262814
[8578.171161] Humanoid.Jump = true
[8578.171600] >>> AUTO RELEASE | JumpHeldDown=false
[8578.171662] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -17.262814 -> -17.679482 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8578.171693] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.679482
[8578.181234] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=16.903847 | CanJump=true | JumpHeld=false | HumJump=false
[8578.187207] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8578.653712] >>> GROUND AUTO JUMP #20 | Hum=Enum.HumanoidStateType.Freefall
[8578.653795] ==================================================
[8578.653815] ORIGINAL JumpReact | REASON=GROUND
[8578.653837] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-4.577885
[8578.653860] Humanoid.Jump = true
[8578.654146] >>> AUTO RELEASE | JumpHeldDown=false
[8578.654169] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy -4.577885 -> 2.109352 | DeltaVy=6.687237 | CanJump=true | JumpHeld=false
[8578.654186] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=2.109352
[8578.664450] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=26.613802 | CanJump=true | JumpHeld=false | HumJump=false
[8578.678901] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8578.687120] >>> GROUND AUTO JUMP #21 | Hum=Enum.HumanoidStateType.Freefall
[8578.687199] ==================================================
[8578.687222] ORIGINAL JumpReact | REASON=GROUND
[8578.687246] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=24.660631
[8578.687268] Humanoid.Jump = true
[8578.687500] >>> AUTO RELEASE | JumpHeldDown=false
[8578.687542] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 24.660631 -> 24.243929 | DeltaVy=-0.416702 | CanJump=true | JumpHeld=false
[8578.687562] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=24.243929
[8578.696587] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=23.827284 | CanJump=true | JumpHeld=false | HumJump=false
[8578.703441] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8578.712202] >>> GROUND AUTO JUMP #22 | Hum=Enum.HumanoidStateType.Freefall
[8578.712284] ==================================================
[8578.712318] ORIGINAL JumpReact | REASON=GROUND
[8578.712352] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=23.410536
[8578.712377] Humanoid.Jump = true
[8578.712702] >>> AUTO RELEASE | JumpHeldDown=false
[8578.712742] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 23.410536 -> 22.993870 | DeltaVy=-0.416666 | CanJump=true | JumpHeld=false
[8578.712763] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=22.993870
[8578.722056] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8578.722345] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=false | Vy=22.577194 | CanJump=true | JumpHeld=false | HumJump=false
[8579.080459] >>> GROUND AUTO JUMP #23 | Hum=Enum.HumanoidStateType.Freefall
[8579.080539] ==================================================
[8579.080560] ORIGINAL JumpReact | REASON=GROUND
[8579.080584] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=5.078582
[8579.080608] Humanoid.Jump = true
[8579.080957] >>> AUTO RELEASE | JumpHeldDown=false
[8579.081050] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 5.078582 -> 42.731876 | DeltaVy=37.653295 | CanJump=true | JumpHeld=false
[8579.081093] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=42.731876
[8579.089577] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=42.107018 | CanJump=true | JumpHeld=false | HumJump=false
[8579.112397] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8580.645570] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-35.601254 | CanJump=true | JumpHeld=false | HumJump=false
[8580.662740] >>> GROUND AUTO JUMP #24 | Hum=Enum.HumanoidStateType.Landed
[8580.662837] ==================================================
[8580.662865] ORIGINAL JumpReact | REASON=GROUND
[8580.662894] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-36.017918
[8580.662925] Humanoid.Jump = true
[8580.663269] >>> AUTO RELEASE | JumpHeldDown=false
[8580.663317] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -36.017918 -> -19.202841 | DeltaVy=16.815077 | CanJump=true | JumpHeld=false
[8580.663343] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-19.202841
[8580.672013] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112175 | CanJump=true | JumpHeld=false | HumJump=false
[8580.703656] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8581.453671] >>> GROUND AUTO JUMP #25 | Hum=Enum.HumanoidStateType.Freefall
[8581.453786] ==================================================
[8581.453814] ORIGINAL JumpReact | REASON=GROUND
[8581.453841] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-21.637827
[8581.453878] Humanoid.Jump = true
[8581.454227] >>> AUTO RELEASE | JumpHeldDown=false
[8581.454254] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy -21.637827 -> 1.057789 | DeltaVy=22.695616 | CanJump=true | JumpHeld=false
[8581.454272] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=1.057789
[8581.463568] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=7.172316 | CanJump=true | JumpHeld=false | HumJump=false
[8581.494936] ==================================================
[8581.495053] NATURAL CLIMBING DETECTED #1
[8581.495069] ==================================================
[8581.495094] ==================================================
[8581.495124] ORIGINAL JumpReact | REASON=NATURAL CLIMBING
[8581.495157] BEFORE | Hum=Enum.HumanoidStateType.Climbing | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=35.571941
[8581.495181] Humanoid.Jump = true
[8581.495207] >>> EndClimb BLOCKED DURING CLIMBING
[8581.495465] >>> AUTO RELEASE | JumpHeldDown=false
[8581.495487] JumpReact RETURNED | State Enum.HumanoidStateType.Climbing -> Enum.HumanoidStateType.Climbing | Vy 35.571941 -> 22.629480 | DeltaVy=-12.942461 | CanJump=true | JumpHeld=false
[8581.495505] AFTER | Hum=Enum.HumanoidStateType.Climbing | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=22.629480
[8581.495528] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Climbing | Grounded=true | Vy=22.629480 | CanJump=true | JumpHeld=false | HumJump=true
[8581.520442] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Climbing | Grounded=true | Vy=4.208054 | CanJump=true | JumpHeld=false | HumJump=false
[8582.245259] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8582.361987] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Freefall | Grounded=false | Vy=7.090838 | CanJump=true | JumpHeld=false | HumJump=false
[8582.703410] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-9.992496 | CanJump=true | JumpHeld=false | HumJump=false
[8582.749140] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-12.284160 | CanJump=true | JumpHeld=false | HumJump=false
[8582.814888] >>> GROUND AUTO JUMP #26 | Hum=Enum.HumanoidStateType.Running
[8582.814969] ==================================================
[8582.814987] ORIGINAL JumpReact | REASON=GROUND
[8582.815014] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-15.200822
[8582.815047] Humanoid.Jump = true
[8582.815372] >>> AUTO RELEASE | JumpHeldDown=false
[8582.815410] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -15.200822 -> -15.617488 | DeltaVy=-0.416666 | CanJump=true | JumpHeld=false
[8582.815434] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-15.617488
[8582.826483] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112177 | CanJump=true | JumpHeld=false | HumJump=false
[8582.832139] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8583.428351] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-13.096145 | CanJump=true | JumpHeld=false | HumJump=false
[8583.479449] >>> GROUND AUTO JUMP #27 | Hum=Enum.HumanoidStateType.Running
[8583.479542] ==================================================
[8583.479565] ORIGINAL JumpReact | REASON=GROUND
[8583.479596] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-15.179475
[8583.479628] Humanoid.Jump = true
[8583.479895] >>> AUTO RELEASE | JumpHeldDown=false
[8583.479922] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -15.179475 -> -15.596141 | DeltaVy=-0.416666 | CanJump=true | JumpHeld=false
[8583.479942] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-15.596141
[8583.479960] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-15.596141 | CanJump=true | JumpHeld=false | HumJump=true
[8583.504220] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8584.253729] >>> GROUND AUTO JUMP #28 | Hum=Enum.HumanoidStateType.Freefall
[8584.253820] ==================================================
[8584.253844] ORIGINAL JumpReact | REASON=GROUND
[8584.253872] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-20.596157
[8584.253904] Humanoid.Jump = true
[8584.254440] >>> AUTO RELEASE | JumpHeldDown=false
[8584.254476] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy -20.596157 -> -10.583054 | DeltaVy=10.013103 | CanJump=true | JumpHeld=false
[8584.254495] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-10.583054
[8584.264263] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=22.911156 | CanJump=true | JumpHeld=false | HumJump=false
[8584.312154] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8585.228435] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-22.195427 | CanJump=true | JumpHeld=false | HumJump=false
[8585.245870] >>> GROUND AUTO JUMP #29 | Hum=Enum.HumanoidStateType.Landed
[8585.245944] ==================================================
[8585.245973] ORIGINAL JumpReact | REASON=GROUND
[8585.246001] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-22.612095
[8585.246031] Humanoid.Jump = true
[8585.246306] >>> AUTO RELEASE | JumpHeldDown=false
[8585.246330] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -22.612095 -> -23.028763 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8585.246350] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-23.028763
[8585.255682] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112177 | CanJump=true | JumpHeld=false | HumJump=false
[8585.287389] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8586.037112] >>> GROUND AUTO JUMP #30 | Hum=Enum.HumanoidStateType.Freefall
[8586.037207] ==================================================
[8586.037230] ORIGINAL JumpReact | REASON=GROUND
[8586.037264] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-21.637825
[8586.037290] Humanoid.Jump = true
[8586.037630] >>> AUTO RELEASE | JumpHeldDown=false
[8586.037654] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy -21.637825 -> -14.759060 | DeltaVy=6.878765 | CanJump=true | JumpHeld=false
[8586.037671] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-14.759060
[8586.046247] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=22.290335 | CanJump=true | JumpHeld=false | HumJump=false
[8586.087039] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8587.329300] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-31.484341 | CanJump=true | JumpHeld=false | HumJump=false
[8587.355755] >>> GROUND AUTO JUMP #31 | Hum=Enum.HumanoidStateType.Landed
[8587.355821] ==================================================
[8587.355840] ORIGINAL JumpReact | REASON=GROUND
[8587.355864] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-32.317673
[8587.355891] Humanoid.Jump = true
[8587.356333] >>> AUTO RELEASE | JumpHeldDown=false
[8587.356364] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -32.317673 -> -16.076235 | DeltaVy=16.241438 | CanJump=true | JumpHeld=false
[8587.356384] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-16.076235
[8587.364805] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112175 | CanJump=true | JumpHeld=false | HumJump=false
[8587.405572] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8588.045315] >>> GROUND AUTO JUMP #32 | Hum=Enum.HumanoidStateType.Freefall
[8588.045403] ==================================================
[8588.045424] ORIGINAL JumpReact | REASON=GROUND
[8588.045448] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.429478
[8588.045472] Humanoid.Jump = true
[8588.045894] >>> AUTO RELEASE | JumpHeldDown=false
[8588.045979] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy -16.429478 -> 11.775014 | DeltaVy=28.204492 | CanJump=true | JumpHeld=false
[8588.046028] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=11.775014
[8588.055561] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.121353 | CanJump=true | JumpHeld=false | HumJump=false
[8588.103609] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8588.753365] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-17.878401 | CanJump=true | JumpHeld=false | HumJump=false
[8588.792272] >>> GROUND AUTO JUMP #33 | Hum=Enum.HumanoidStateType.Landed
[8588.792337] ==================================================
[8588.792379] ORIGINAL JumpReact | REASON=GROUND
[8588.792401] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-19.545073
[8588.792447] Humanoid.Jump = true
[8588.792799] >>> AUTO RELEASE | JumpHeldDown=false
[8588.792886] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -19.545073 -> -9.545119 | DeltaVy=9.999953 | CanJump=true | JumpHeld=false
[8588.792931] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-9.545119
[8588.797188] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.320507 | CanJump=true | JumpHeld=false | HumJump=false
[8588.844545] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8589.530027] >>> GROUND AUTO JUMP #34 | Hum=Enum.HumanoidStateType.Freefall
[8589.530228] ==================================================
[8589.530258] ORIGINAL JumpReact | REASON=GROUND
[8589.530279] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-0.554867
[8589.530300] Humanoid.Jump = true
[8589.530582] >>> AUTO RELEASE | JumpHeldDown=false
[8589.530617] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy -0.554867 -> 23.250702 | DeltaVy=23.805569 | CanJump=true | JumpHeld=false
[8589.530640] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=23.250702
[8589.538249] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=25.123018 | CanJump=true | JumpHeld=false | HumJump=false
[8589.560494] STATE: Enum.HumanoidStateType.Climbing -> Enum.HumanoidStateType.Running | Grounded=true | Vy=16.380863 | CanJump=true | JumpHeld=false | HumJump=false
[8591.105922] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8591.255500] >>> GROUND AUTO JUMP #35 | Hum=Enum.HumanoidStateType.Running
[8591.255649] ==================================================
[8591.255682] ORIGINAL JumpReact | REASON=GROUND
[8591.255710] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-13.895396
[8591.255751] Humanoid.Jump = true
[8591.256058] >>> AUTO RELEASE | JumpHeldDown=false
[8591.256104] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -13.895396 -> -14.312062 | DeltaVy=-0.416666 | CanJump=true | JumpHeld=false
[8591.256127] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-14.312062
[8591.266292] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=16.903843 | CanJump=true | JumpHeld=false | HumJump=false
[8591.271978] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8591.919982] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-15.804474 | CanJump=true | JumpHeld=false | HumJump=false
[8591.961275] >>> GROUND AUTO JUMP #36 | Hum=Enum.HumanoidStateType.Landed
[8591.961375] ==================================================
[8591.961404] ORIGINAL JumpReact | REASON=GROUND
[8591.961434] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.471146
[8591.961473] Humanoid.Jump = true
[8591.961935] >>> AUTO RELEASE | JumpHeldDown=false
[8591.961999] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -17.471146 -> -17.887814 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8591.962031] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.887814
[8591.972558] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112175 | CanJump=true | JumpHeld=false | HumJump=false
[8591.978971] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8592.586829] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-13.512813 | CanJump=true | JumpHeld=false | HumJump=false
[8592.636150] >>> GROUND AUTO JUMP #37 | Hum=Enum.HumanoidStateType.Running
[8592.636234] ==================================================
[8592.636263] ORIGINAL JumpReact | REASON=GROUND
[8592.636294] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-15.596143
[8592.636324] Humanoid.Jump = true
[8592.636716] >>> AUTO RELEASE | JumpHeldDown=false
[8592.636751] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -15.596143 -> -16.012810 | DeltaVy=-0.416667 | CanJump=true | JumpHeld=false
[8592.636778] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-16.012810
[8592.636802] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-16.012810 | CanJump=true | JumpHeld=false | HumJump=true
[8592.669656] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8593.195370] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-10.387812 | CanJump=true | JumpHeld=false | HumJump=false
[8593.244322] >>> GROUND AUTO JUMP #38 | Hum=Enum.HumanoidStateType.Running
[8593.244382] ==================================================
[8593.244396] ORIGINAL JumpReact | REASON=GROUND
[8593.244417] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-12.471142
[8593.244440] Humanoid.Jump = true
[8593.244638] >>> AUTO RELEASE | JumpHeldDown=false
[8593.244656] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -12.471142 -> -12.887808 | DeltaVy=-0.416666 | CanJump=true | JumpHeld=false
[8593.244670] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-12.887808
[8593.244687] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-12.887808 | CanJump=true | JumpHeld=false | HumJump=true
[8593.269242] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8594.112707] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-25.804506 | CanJump=true | JumpHeld=false | HumJump=false
[8594.136489] >>> GROUND AUTO JUMP #39 | Hum=Enum.HumanoidStateType.Landed
[8594.136550] ==================================================
[8594.136569] ORIGINAL JumpReact | REASON=GROUND
[8594.136590] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-26.637842
[8594.136611] Humanoid.Jump = true
[8594.136816] >>> AUTO RELEASE | JumpHeldDown=false
[8594.136842] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -26.637842 -> -27.054510 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8594.136860] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-27.054510
[8594.147989] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=16.903841 | CanJump=true | JumpHeld=false | HumJump=false
[8594.160975] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8594.780161] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.554478 | CanJump=true | JumpHeld=false | HumJump=false
[8594.826689] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-16.846146 | CanJump=true | JumpHeld=false | HumJump=false
[8594.834999] >>> GROUND AUTO JUMP #40 | Hum=Enum.HumanoidStateType.Running
[8594.835089] ==================================================
[8594.835111] ORIGINAL JumpReact | REASON=GROUND
[8594.835135] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.846146
[8594.835166] Humanoid.Jump = true
[8594.835655] >>> AUTO RELEASE | JumpHeldDown=false
[8594.835681] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -16.846146 -> -17.471148 | DeltaVy=-0.625002 | CanJump=true | JumpHeld=false
[8594.835697] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.471148
[8594.857385] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=true | Vy=16.487173 | CanJump=true | JumpHeld=false | HumJump=false
[8594.864511] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8595.477752] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.554478 | CanJump=true | JumpHeld=false | HumJump=false
[8595.528427] >>> GROUND AUTO JUMP #41 | Hum=Enum.HumanoidStateType.Running
[8595.528489] ==================================================
[8595.528509] ORIGINAL JumpReact | REASON=GROUND
[8595.528532] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.637812
[8595.528555] Humanoid.Jump = true
[8595.528785] >>> AUTO RELEASE | JumpHeldDown=false
[8595.528806] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -16.637812 -> -17.054480 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8595.528823] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.054480
[8595.528841] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-17.054480 | CanJump=true | JumpHeld=false | HumJump=true
[8595.552745] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8596.177981] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.971140 | CanJump=true | JumpHeld=false | HumJump=false
[8596.229205] >>> GROUND AUTO JUMP #42 | Hum=Enum.HumanoidStateType.Running
[8596.229310] ==================================================
[8596.229333] ORIGINAL JumpReact | REASON=GROUND
[8596.229360] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.054476
[8596.229388] Humanoid.Jump = true
[8596.229634] >>> AUTO RELEASE | JumpHeldDown=false
[8596.229665] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -17.054476 -> -17.471144 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8596.229684] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.471144
[8596.229703] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-17.471144 | CanJump=true | JumpHeld=false | HumJump=true
[8596.252708] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8596.870601] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.554478 | CanJump=true | JumpHeld=false | HumJump=false
[8596.920295] >>> GROUND AUTO JUMP #43 | Hum=Enum.HumanoidStateType.Running
[8596.920361] ==================================================
[8596.920380] ORIGINAL JumpReact | REASON=GROUND
[8596.920400] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.637812
[8596.920421] Humanoid.Jump = true
[8596.920704] >>> AUTO RELEASE | JumpHeldDown=false
[8596.920729] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -16.637812 -> -17.054480 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8596.920745] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.054480
[8596.920761] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-17.054480 | CanJump=true | JumpHeld=false | HumJump=true
[8596.944266] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8597.320799] >>> GROUND AUTO JUMP #44 | Hum=Enum.HumanoidStateType.Freefall
[8597.320883] ==================================================
[8597.320904] ORIGINAL JumpReact | REASON=GROUND
[8597.320928] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=3.370214
[8597.320956] Humanoid.Jump = true
[8597.321326] >>> AUTO RELEASE | JumpHeldDown=false
[8597.321412] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 3.370214 -> 13.186443 | DeltaVy=9.816229 | CanJump=true | JumpHeld=false
[8597.321453] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=13.186443
[8597.330044] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=18.192083 | CanJump=true | JumpHeld=false | HumJump=false
[8597.352865] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Climbing | Grounded=true | Vy=6.618331 | CanJump=true | JumpHeld=false | HumJump=false
[8597.453028] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8597.461743] >>> GROUND AUTO JUMP #45 | Hum=Enum.HumanoidStateType.Running
[8597.461800] ==================================================
[8597.461819] ORIGINAL JumpReact | REASON=GROUND
[8597.461863] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-2.441888
[8597.461891] Humanoid.Jump = true
[8597.462192] >>> AUTO RELEASE | JumpHeldDown=false
[8597.462320] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -2.441888 -> -3.379457 | DeltaVy=-0.937569 | CanJump=true | JumpHeld=false
[8597.462363] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-3.379457
[8597.470897] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112177 | CanJump=true | JumpHeld=false | HumJump=false
[8597.478253] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8598.110837] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.971142 | CanJump=true | JumpHeld=false | HumJump=false
[8598.161942] >>> GROUND AUTO JUMP #46 | Hum=Enum.HumanoidStateType.Running
[8598.162067] ==================================================
[8598.162095] ORIGINAL JumpReact | REASON=GROUND
[8598.162131] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.054478
[8598.162174] Humanoid.Jump = true
[8598.162645] >>> AUTO RELEASE | JumpHeldDown=false
[8598.162679] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -17.054478 -> -6.709343 | DeltaVy=10.345135 | CanJump=true | JumpHeld=false
[8598.162700] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-6.709343
[8598.162723] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-6.709343 | CanJump=true | JumpHeld=false | HumJump=true
[8598.178489] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8598.843911] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-16.637812 | CanJump=true | JumpHeld=false | HumJump=false
[8598.869732] >>> GROUND AUTO JUMP #47 | Hum=Enum.HumanoidStateType.Landed
[8598.869795] ==================================================
[8598.869813] ORIGINAL JumpReact | REASON=GROUND
[8598.869833] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.471148
[8598.869854] Humanoid.Jump = true
[8598.870064] >>> AUTO RELEASE | JumpHeldDown=false
[8598.870089] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -17.471148 -> -17.887815 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8598.870107] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.887815
[8598.879334] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112175 | CanJump=true | JumpHeld=false | HumJump=false
[8598.902831] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8599.637851] >>> GROUND AUTO JUMP #48 | Hum=Enum.HumanoidStateType.Landed
[8599.637906] ==================================================
[8599.637922] ORIGINAL JumpReact | REASON=GROUND
[8599.637941] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-15.459952
[8599.637958] Humanoid.Jump = true
[8599.638226] >>> AUTO RELEASE | JumpHeldDown=false
[8599.638248] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -15.459952 -> 0.281794 | DeltaVy=15.741746 | CanJump=true | JumpHeld=false
[8599.638262] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=0.281794
[8599.638288] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=true | Vy=0.281794 | CanJump=true | JumpHeld=false | HumJump=true
[8599.693833] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8601.102863] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-46.340504 | CanJump=true | JumpHeld=false | HumJump=false
[8601.119887] >>> GROUND AUTO JUMP #49 | Hum=Enum.HumanoidStateType.Landed
[8601.119991] ==================================================
[8601.120020] ORIGINAL JumpReact | REASON=GROUND
[8601.120048] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-46.757168
[8601.120078] Humanoid.Jump = true
[8601.120559] >>> AUTO RELEASE | JumpHeldDown=false
[8601.120633] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -46.757168 -> -10.802295 | DeltaVy=35.954873 | CanJump=true | JumpHeld=false
[8601.120679] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-10.802295
[8601.130425] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112177 | CanJump=true | JumpHeld=false | HumJump=false
[8601.153168] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8601.744547] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-13.721144 | CanJump=true | JumpHeld=false | HumJump=false
[8601.795289] >>> GROUND AUTO JUMP #50 | Hum=Enum.HumanoidStateType.Running
[8601.795394] ==================================================
[8601.795420] ORIGINAL JumpReact | REASON=GROUND
[8601.795452] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-15.804474
[8601.795482] Humanoid.Jump = true
[8601.795853] >>> AUTO RELEASE | JumpHeldDown=false
[8601.795908] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -15.804474 -> -16.221142 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8601.795935] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-16.221142
[8601.795961] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-16.221142 | CanJump=true | JumpHeld=false | HumJump=true
[8601.811148] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8601.819038] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=false | Vy=16.487173 | CanJump=true | JumpHeld=false | HumJump=false
[8602.460795] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-15.596143 | CanJump=true | JumpHeld=false | HumJump=false
[8602.502884] >>> GROUND AUTO JUMP #51 | Hum=Enum.HumanoidStateType.Landed
[8602.502960] ==================================================
[8602.502980] ORIGINAL JumpReact | REASON=GROUND
[8602.503000] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.262814
[8602.503020] Humanoid.Jump = true
[8602.503262] >>> AUTO RELEASE | JumpHeldDown=false
[8602.503314] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -17.262814 -> -17.679482 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8602.503337] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.679482
[8602.512420] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112181 | CanJump=true | JumpHeld=false | HumJump=false
[8602.527361] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8602.578004] >>> GROUND AUTO JUMP #52 | Hum=Enum.HumanoidStateType.Freefall
[8602.578036] ==================================================
[8602.578048] ORIGINAL JumpReact | REASON=GROUND
[8602.578066] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=14.403847
[8602.578084] Humanoid.Jump = true
[8602.578276] >>> AUTO RELEASE | JumpHeldDown=false
[8602.578294] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 14.403847 -> 13.778848 | DeltaVy=-0.624999 | CanJump=true | JumpHeld=false
[8602.578309] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=13.778848
[8602.587530] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112175 | CanJump=true | JumpHeld=false | HumJump=false
[8602.610949] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8603.304150] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-18.721151 | CanJump=true | JumpHeld=false | HumJump=false
[8603.338233] >>> GROUND AUTO JUMP #53 | Hum=Enum.HumanoidStateType.Landed
[8603.338303] ==================================================
[8603.338323] ORIGINAL JumpReact | REASON=GROUND
[8603.338347] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-19.971155
[8603.338382] Humanoid.Jump = true
[8603.338612] >>> AUTO RELEASE | JumpHeldDown=false
[8603.338651] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -19.971155 -> -20.387823 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8603.338670] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-20.387823
[8603.347853] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=16.903841 | CanJump=true | JumpHeld=false | HumJump=false
[8603.354883] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8603.811267] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=1.243252 | CanJump=true | JumpHeld=false | HumJump=false
[8603.819660] >>> GROUND AUTO JUMP #54 | Hum=Enum.HumanoidStateType.Landed
[8603.819714] ==================================================
[8603.819735] ORIGINAL JumpReact | REASON=GROUND
[8603.819763] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=1.243792
[8603.819786] Humanoid.Jump = true
[8603.820195] >>> AUTO RELEASE | JumpHeldDown=false
[8603.820231] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy 1.243792 -> 24.393538 | DeltaVy=23.149746 | CanJump=true | JumpHeld=false
[8603.820252] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=24.393538
[8603.830041] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8603.835769] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=false | Vy=28.001392 | CanJump=true | JumpHeld=false | HumJump=false
[8603.844637] >>> GROUND AUTO JUMP #55 | Hum=Enum.HumanoidStateType.Freefall
[8603.844698] ==================================================
[8603.844720] ORIGINAL JumpReact | REASON=GROUND
[8603.844744] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=28.001551
[8603.844765] Humanoid.Jump = true
[8603.845032] >>> AUTO RELEASE | JumpHeldDown=false
[8603.845067] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 28.001551 -> 27.584774 | DeltaVy=-0.416777 | CanJump=true | JumpHeld=false
[8603.845088] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=27.584774
[8603.864071] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8603.865328] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=false | Vy=26.543108 | CanJump=true | JumpHeld=false | HumJump=false
[8604.196613] >>> GROUND AUTO JUMP #56 | Hum=Enum.HumanoidStateType.Freefall
[8604.196688] ==================================================
[8604.196710] ORIGINAL JumpReact | REASON=GROUND
[8604.196735] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=10.501445
[8604.196759] Humanoid.Jump = true
[8604.197074] >>> AUTO RELEASE | JumpHeldDown=false
[8604.197099] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 10.501445 -> 10.084779 | DeltaVy=-0.416666 | CanJump=true | JumpHeld=false
[8604.197114] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=10.084779
[8604.205729] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112175 | CanJump=true | JumpHeld=false | HumJump=false
[8604.237613] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8604.644782] >>> GROUND AUTO JUMP #57 | Hum=Enum.HumanoidStateType.Freefall
[8604.644901] ==================================================
[8604.644957] ORIGINAL JumpReact | REASON=GROUND
[8604.645009] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=10.140296
[8604.645038] Humanoid.Jump = true
[8604.645290] >>> AUTO RELEASE | JumpHeldDown=false
[8604.645328] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 10.140296 -> 17.935390 | DeltaVy=7.795094 | CanJump=true | JumpHeld=false
[8604.645350] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=17.935390
[8604.654072] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=18.953621 | CanJump=true | JumpHeld=false | HumJump=false
[8604.827334] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8604.963386] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-5.344206 | CanJump=true | JumpHeld=false | HumJump=false
[8605.013019] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=4.035009 | CanJump=true | JumpHeld=false | HumJump=false
[8605.137141] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Freefall | Grounded=false | Vy=5.046591 | CanJump=true | JumpHeld=false | HumJump=false
[8605.402279] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-8.286744 | CanJump=true | JumpHeld=false | HumJump=false
[8605.451802] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-10.786740 | CanJump=true | JumpHeld=false | HumJump=false
[8605.511281] >>> GROUND AUTO JUMP #58 | Hum=Enum.HumanoidStateType.Running
[8605.511351] ==================================================
[8605.511367] ORIGINAL JumpReact | REASON=GROUND
[8605.511389] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-13.286736
[8605.511414] Humanoid.Jump = true
[8605.511746] >>> AUTO RELEASE | JumpHeldDown=false
[8605.511789] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -13.286736 -> -13.703403 | DeltaVy=-0.416666 | CanJump=true | JumpHeld=false
[8605.511812] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-13.703403
[8605.521183] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.320509 | CanJump=true | JumpHeld=false | HumJump=false
[8605.527760] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8606.278084] >>> GROUND AUTO JUMP #59 | Hum=Enum.HumanoidStateType.Freefall
[8606.278241] ==================================================
[8606.278266] ORIGINAL JumpReact | REASON=GROUND
[8606.278292] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-12.556949
[8606.278319] Humanoid.Jump = true
[8606.278669] >>> AUTO RELEASE | JumpHeldDown=false
[8606.278710] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy -12.556949 -> 0.491044 | DeltaVy=13.047993 | CanJump=true | JumpHeld=false
[8606.278733] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=0.491044
[8606.287919] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=18.800236 | CanJump=true | JumpHeld=false | HumJump=false
[8606.345313] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8607.235939] >>> GROUND AUTO JUMP #60 | Hum=Enum.HumanoidStateType.Landed
[8607.236032] ==================================================
[8607.236054] ORIGINAL JumpReact | REASON=GROUND
[8607.236078] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-22.398584
[8607.236104] Humanoid.Jump = true
[8607.236402] >>> AUTO RELEASE | JumpHeldDown=false
[8607.236445] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -22.398584 -> -2.283278 | DeltaVy=20.115307 | CanJump=true | JumpHeld=false
[8607.236467] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-2.283278
[8607.236490] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=true | Vy=-2.283278 | CanJump=true | JumpHeld=false | HumJump=true
[8607.252088] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8607.895351] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-15.387808 | CanJump=true | JumpHeld=false | HumJump=false
[8607.937787] >>> GROUND AUTO JUMP #61 | Hum=Enum.HumanoidStateType.Landed
[8607.937865] ==================================================
[8607.937891] ORIGINAL JumpReact | REASON=GROUND
[8607.937912] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.054478
[8607.937936] Humanoid.Jump = true
[8607.938184] >>> AUTO RELEASE | JumpHeldDown=false
[8607.938212] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -17.054478 -> -8.871610 | DeltaVy=8.182868 | CanJump=true | JumpHeld=false
[8607.938230] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-8.871610
[8607.947119] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8607.947308] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=false | Vy=17.112177 | CanJump=true | JumpHeld=false | HumJump=false
[8608.655935] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-18.512815 | CanJump=true | JumpHeld=false | HumJump=false
[8608.696595] >>> GROUND AUTO JUMP #62 | Hum=Enum.HumanoidStateType.Landed
[8608.696657] ==================================================
[8608.696672] ORIGINAL JumpReact | REASON=GROUND
[8608.696689] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-20.179487
[8608.696707] Humanoid.Jump = true
[8608.697979] >>> AUTO RELEASE | JumpHeldDown=false
[8608.698025] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -20.179487 -> -20.387821 | DeltaVy=-0.208334 | CanJump=true | JumpHeld=false
[8608.698051] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-20.387821
[8608.703512] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.320509 | CanJump=true | JumpHeld=false | HumJump=false
[8608.729279] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8609.403374] >>> GROUND AUTO JUMP #63 | Hum=Enum.HumanoidStateType.Landed
[8609.403488] ==================================================
[8609.403524] ORIGINAL JumpReact | REASON=GROUND
[8609.403553] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-4.869741
[8609.403589] Humanoid.Jump = true
[8609.404116] >>> AUTO RELEASE | JumpHeldDown=false
[8609.404174] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -4.869741 -> 23.037050 | DeltaVy=27.906792 | CanJump=true | JumpHeld=false
[8609.404199] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=23.037050
[8609.404227] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=true | Vy=23.037050 | CanJump=true | JumpHeld=false | HumJump=true
[8609.452463] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8610.260731] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-19.878637 | CanJump=true | JumpHeld=false | HumJump=false
[8610.311455] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-22.378645 | CanJump=true | JumpHeld=false | HumJump=false
[8610.386148] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Freefall | Grounded=false | Vy=-26.128656 | CanJump=true | JumpHeld=false | HumJump=false
[8610.753902] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-44.461933 | CanJump=true | JumpHeld=false | HumJump=false
[8610.769197] >>> GROUND AUTO JUMP #64 | Hum=Enum.HumanoidStateType.Landed
[8610.769239] ==================================================
[8610.769254] ORIGINAL JumpReact | REASON=GROUND
[8610.769271] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-44.878597
[8610.769288] Humanoid.Jump = true
[8610.769507] >>> AUTO RELEASE | JumpHeldDown=false
[8610.769558] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -44.878597 -> -10.573019 | DeltaVy=34.305578 | CanJump=true | JumpHeld=false
[8610.769584] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-10.573019
[8610.779960] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112175 | CanJump=true | JumpHeld=false | HumJump=false
[8610.802502] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8611.404911] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.137812 | CanJump=true | JumpHeld=false | HumJump=false
[8611.456244] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-11.239179 | CanJump=true | JumpHeld=false | HumJump=false
[8611.465627] >>> GROUND AUTO JUMP #65 | Hum=Enum.HumanoidStateType.Running
[8611.465750] ==================================================
[8611.465795] ORIGINAL JumpReact | REASON=GROUND
[8611.465820] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-11.239179
[8611.465844] Humanoid.Jump = true
[8611.466862] >>> AUTO RELEASE | JumpHeldDown=false
[8611.466900] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -11.239179 -> -2.486859 | DeltaVy=8.752319 | CanJump=true | JumpHeld=false
[8611.466932] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-2.486859
[8611.477497] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=true | Vy=16.903843 | CanJump=true | JumpHeld=false | HumJump=false
[8611.490238] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8612.093703] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-13.929477 | CanJump=true | JumpHeld=false | HumJump=false
[8612.119765] >>> GROUND AUTO JUMP #66 | Hum=Enum.HumanoidStateType.Landed
[8612.119885] ==================================================
[8612.119920] ORIGINAL JumpReact | REASON=GROUND
[8612.119947] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-14.762809
[8612.119971] Humanoid.Jump = true
[8612.120213] >>> AUTO RELEASE | JumpHeldDown=false
[8612.120250] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -14.762809 -> -15.179475 | DeltaVy=-0.416666 | CanJump=true | JumpHeld=false
[8612.120274] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-15.179475
[8612.129123] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112177 | CanJump=true | JumpHeld=false | HumJump=false
[8612.330598] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8614.088551] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-13.293282 | CanJump=true | JumpHeld=false | HumJump=false
[8614.136418] >>> GROUND AUTO JUMP #67 | Hum=Enum.HumanoidStateType.Running
[8614.136489] ==================================================
[8614.136506] ORIGINAL JumpReact | REASON=GROUND
[8614.136533] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-15.376612
[8614.136563] Humanoid.Jump = true
[8614.136925] >>> AUTO RELEASE | JumpHeldDown=false
[8614.136962] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -15.376612 -> -15.793278 | DeltaVy=-0.416666 | CanJump=true | JumpHeld=false
[8614.136986] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-15.793278
[8614.137018] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-15.793278 | CanJump=true | JumpHeld=false | HumJump=true
[8614.152413] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8614.161134] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=false | Vy=16.487173 | CanJump=true | JumpHeld=false | HumJump=false
[8614.794192] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-15.179477 | CanJump=true | JumpHeld=false | HumJump=false
[8614.844311] >>> GROUND AUTO JUMP #68 | Hum=Enum.HumanoidStateType.Running
[8614.844360] ==================================================
[8614.844377] ORIGINAL JumpReact | REASON=GROUND
[8614.844398] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.262814
[8614.844420] Humanoid.Jump = true
[8614.844701] >>> AUTO RELEASE | JumpHeldDown=false
[8614.844729] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -17.262814 -> -17.679482 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8614.844749] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.679482
[8614.844769] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-17.679482 | CanJump=true | JumpHeld=false | HumJump=true
[8614.869517] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=true | Vy=-1.650573 | CanJump=true | JumpHeld=false | HumJump=false
[8614.919234] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=2.934369 | CanJump=true | JumpHeld=false | HumJump=false
[8616.563860] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112177 | CanJump=false | JumpHeld=true | HumJump=false
[8616.585850] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8617.196709] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.554476 | CanJump=true | JumpHeld=false | HumJump=false
[8617.243616] >>> GROUND AUTO JUMP #69 | Hum=Enum.HumanoidStateType.Running
[8617.243679] ==================================================
[8617.243697] ORIGINAL JumpReact | REASON=GROUND
[8617.243715] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Idle | Reg=Idle | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.637810
[8617.243734] Humanoid.Jump = true
[8617.243900] >>> AUTO RELEASE | JumpHeldDown=false
[8617.243923] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -16.637810 -> -17.054478 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8617.243935] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Idle | Reg=Idle | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.054478
[8617.243948] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-17.054478 | CanJump=true | JumpHeld=false | HumJump=true
[8617.268355] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8617.897178] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.971142 | CanJump=true | JumpHeld=false | HumJump=false
[8617.939972] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-17.262812 | CanJump=true | JumpHeld=false | HumJump=false
[8617.948231] >>> GROUND AUTO JUMP #70 | Hum=Enum.HumanoidStateType.Running
[8617.948319] ==================================================
[8617.948347] ORIGINAL JumpReact | REASON=GROUND
[8617.948373] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.262812
[8617.948400] Humanoid.Jump = true
[8617.948718] >>> AUTO RELEASE | JumpHeldDown=false
[8617.948760] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -17.262812 -> -17.679480 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8617.948784] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.679480
[8617.962704] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=true | Vy=16.903845 | CanJump=true | JumpHeld=false | HumJump=false
[8617.980612] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8618.460305] >>> GROUND AUTO JUMP #71 | Hum=Enum.HumanoidStateType.Freefall
[8618.460372] ==================================================
[8618.460388] ORIGINAL JumpReact | REASON=GROUND
[8618.460409] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-7.679484
[8618.460431] Humanoid.Jump = true
[8618.460729] >>> AUTO RELEASE | JumpHeldDown=false
[8618.460761] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy -7.679484 -> 10.618609 | DeltaVy=18.298093 | CanJump=true | JumpHeld=false
[8618.460782] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=10.618609
[8618.470770] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=23.732521 | CanJump=true | JumpHeld=false | HumJump=false
[8618.502607] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Climbing | Grounded=true | Vy=11.282249 | CanJump=true | JumpHeld=false | HumJump=false
[8618.560108] STATE: Enum.HumanoidStateType.Climbing -> Enum.HumanoidStateType.Running | Grounded=true | Vy=13.157804 | CanJump=true | JumpHeld=false | HumJump=false
[8619.144048] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8619.260924] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Freefall | Grounded=false | Vy=0.331529 | CanJump=true | JumpHeld=false | HumJump=false
[8619.706228] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-21.960146 | CanJump=true | JumpHeld=false | HumJump=false
[8619.728992] >>> GROUND AUTO JUMP #72 | Hum=Enum.HumanoidStateType.Landed
[8619.729079] ==================================================
[8619.729102] ORIGINAL JumpReact | REASON=GROUND
[8619.729125] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-22.585148
[8619.729151] Humanoid.Jump = true
[8619.729539] >>> AUTO RELEASE | JumpHeldDown=false
[8619.729584] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -22.585148 -> -23.001816 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8619.729608] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-23.001816
[8619.739967] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=16.903843 | CanJump=true | JumpHeld=false | HumJump=false
[8619.754315] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8620.368546] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.554476 | CanJump=true | JumpHeld=false | HumJump=false
[8620.410120] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-16.637810 | CanJump=true | JumpHeld=false | HumJump=false
[8620.419922] >>> GROUND AUTO JUMP #73 | Hum=Enum.HumanoidStateType.Running
[8620.420005] ==================================================
[8620.420026] ORIGINAL JumpReact | REASON=GROUND
[8620.420057] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.637810
[8620.420089] Humanoid.Jump = true
[8620.420562] >>> AUTO RELEASE | JumpHeldDown=false
[8620.420655] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -16.637810 -> -17.054478 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8620.420700] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.054478
[8620.435316] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=true | Vy=16.695509 | CanJump=true | JumpHeld=false | HumJump=false
[8620.444116] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8621.068079] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.762809 | CanJump=true | JumpHeld=false | HumJump=false
[8621.110549] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-17.054478 | CanJump=true | JumpHeld=false | HumJump=false
[8621.119156] >>> GROUND AUTO JUMP #74 | Hum=Enum.HumanoidStateType.Running
[8621.119237] ==================================================
[8621.119263] ORIGINAL JumpReact | REASON=GROUND
[8621.119287] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.054478
[8621.119311] Humanoid.Jump = true
[8621.120773] >>> AUTO RELEASE | JumpHeldDown=false
[8621.120837] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -17.054478 -> -17.471146 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8621.120863] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.471146
[8621.136052] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=true | Vy=16.695509 | CanJump=true | JumpHeld=false | HumJump=false
[8621.143829] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8621.776737] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-15.387808 | CanJump=true | JumpHeld=false | HumJump=false
[8621.818493] >>> GROUND AUTO JUMP #75 | Hum=Enum.HumanoidStateType.Running
[8621.818558] ==================================================
[8621.818576] ORIGINAL JumpReact | REASON=GROUND
[8621.818597] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.054478
[8621.818620] Humanoid.Jump = true
[8621.818864] >>> AUTO RELEASE | JumpHeldDown=false
[8621.818895] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -17.054478 -> -17.471146 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8621.818916] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.471146
[8621.818935] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-17.471146 | CanJump=true | JumpHeld=false | HumJump=true
[8621.843536] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8622.336413] >>> GROUND AUTO JUMP #76 | Hum=Enum.HumanoidStateType.Freefall
[8622.336486] ==================================================
[8622.336505] ORIGINAL JumpReact | REASON=GROUND
[8622.336531] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-4.611693
[8622.336564] Humanoid.Jump = true
[8622.336973] >>> AUTO RELEASE | JumpHeldDown=false
[8622.337024] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy -4.611693 -> 6.671772 | DeltaVy=11.283465 | CanJump=true | JumpHeld=false
[8622.337048] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=6.671772
[8622.345113] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=20.281260 | CanJump=true | JumpHeld=false | HumJump=false
[8622.380367] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Climbing | Grounded=true | Vy=19.192099 | CanJump=true | JumpHeld=false | HumJump=false
[8622.422629] STATE: Enum.HumanoidStateType.Climbing -> Enum.HumanoidStateType.Running | Grounded=true | Vy=18.689545 | CanJump=true | JumpHeld=false | HumJump=false
[8622.859768] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8622.976770] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Freefall | Grounded=false | Vy=-1.292846 | CanJump=true | JumpHeld=false | HumJump=false
[8623.719020] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-38.376179 | CanJump=true | JumpHeld=false | HumJump=false
[8623.735282] >>> GROUND AUTO JUMP #77 | Hum=Enum.HumanoidStateType.Landed
[8623.735362] ==================================================
[8623.735389] ORIGINAL JumpReact | REASON=GROUND
[8623.735412] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-38.792843
[8623.735437] Humanoid.Jump = true
[8623.735744] >>> AUTO RELEASE | JumpHeldDown=false
[8623.735797] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -38.792843 -> -9.181323 | DeltaVy=29.611520 | CanJump=true | JumpHeld=false
[8623.735832] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-9.181323
[8623.745572] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.320509 | CanJump=true | JumpHeld=false | HumJump=false
[8623.776835] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8624.378854] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.346145 | CanJump=true | JumpHeld=false | HumJump=false
[8624.429210] >>> GROUND AUTO JUMP #78 | Hum=Enum.HumanoidStateType.Running
[8624.429258] ==================================================
[8624.429275] ORIGINAL JumpReact | REASON=GROUND
[8624.429294] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.429478
[8624.429314] Humanoid.Jump = true
[8624.429514] >>> AUTO RELEASE | JumpHeldDown=false
[8624.429533] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -16.429478 -> -8.887120 | DeltaVy=7.542357 | CanJump=true | JumpHeld=false
[8624.429547] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-8.887120
[8624.429562] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-8.887120 | CanJump=true | JumpHeld=false | HumJump=true
[8624.454174] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8625.085538] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-15.387808 | CanJump=true | JumpHeld=false | HumJump=false
[8625.132151] >>> GROUND AUTO JUMP #79 | Hum=Enum.HumanoidStateType.Running
[8625.132271] ==================================================
[8625.132300] ORIGINAL JumpReact | REASON=GROUND
[8625.132327] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.471146
[8625.132357] Humanoid.Jump = true
[8625.132733] >>> AUTO RELEASE | JumpHeldDown=false
[8625.132782] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -17.471146 -> -17.679480 | DeltaVy=-0.208334 | CanJump=true | JumpHeld=false
[8625.132807] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.679480
[8625.132829] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-17.679480 | CanJump=true | JumpHeld=false | HumJump=true
[8625.155763] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8625.768843] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.346141 | CanJump=true | JumpHeld=false | HumJump=false
[8625.818694] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-16.846142 | CanJump=true | JumpHeld=false | HumJump=false
[8625.828680] >>> GROUND AUTO JUMP #80 | Hum=Enum.HumanoidStateType.Running
[8625.828745] ==================================================
[8625.828763] ORIGINAL JumpReact | REASON=GROUND
[8625.828787] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.846142
[8625.828812] Humanoid.Jump = true
[8625.829213] >>> AUTO RELEASE | JumpHeldDown=false
[8625.829284] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -16.846142 -> -4.275753 | DeltaVy=12.570388 | CanJump=true | JumpHeld=false
[8625.829315] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-4.275753
[8625.843422] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=true | Vy=16.695507 | CanJump=true | JumpHeld=false | HumJump=false
[8625.852433] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8626.476021] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.762811 | CanJump=true | JumpHeld=false | HumJump=false
[8626.517439] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-16.846146 | CanJump=true | JumpHeld=false | HumJump=false
[8626.527637] >>> GROUND AUTO JUMP #81 | Hum=Enum.HumanoidStateType.Running
[8626.527698] ==================================================
[8626.527731] ORIGINAL JumpReact | REASON=GROUND
[8626.527752] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.846146
[8626.527774] Humanoid.Jump = true
[8626.528098] >>> AUTO RELEASE | JumpHeldDown=false
[8626.528139] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -16.846146 -> -9.115371 | DeltaVy=7.730775 | CanJump=true | JumpHeld=false
[8626.528162] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-9.115371
[8626.551619] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8626.551973] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=false | Vy=16.487173 | CanJump=true | JumpHeld=false | HumJump=false
[8627.187258] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-15.179477 | CanJump=true | JumpHeld=false | HumJump=false
[8627.236833] >>> GROUND AUTO JUMP #82 | Hum=Enum.HumanoidStateType.Running
[8627.236899] ==================================================
[8627.236918] ORIGINAL JumpReact | REASON=GROUND
[8627.236937] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.262814
[8627.236960] Humanoid.Jump = true
[8627.237239] >>> AUTO RELEASE | JumpHeldDown=false
[8627.237259] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -17.262814 -> -8.663644 | DeltaVy=8.599170 | CanJump=true | JumpHeld=false
[8627.237273] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-8.663644
[8627.237288] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-8.663644 | CanJump=true | JumpHeld=false | HumJump=true
[8627.262255] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8627.270359] >>> GROUND AUTO JUMP #83 | Hum=Enum.HumanoidStateType.Freefall
[8627.270422] ==================================================
[8627.270440] ORIGINAL JumpReact | REASON=GROUND
[8627.270458] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=14.648834
[8627.270479] Humanoid.Jump = true
[8627.270774] >>> AUTO RELEASE | JumpHeldDown=false
[8627.270795] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 14.648834 -> 14.887924 | DeltaVy=0.239090 | CanJump=true | JumpHeld=false
[8627.270808] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=14.887924
[8627.279876] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8627.280149] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=false | Vy=18.427351 | CanJump=true | JumpHeld=false | HumJump=false
[8627.286942] >>> GROUND AUTO JUMP #84 | Hum=Enum.HumanoidStateType.Freefall
[8627.286994] ==================================================
[8627.287010] ORIGINAL JumpReact | REASON=GROUND
[8627.287026] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=18.427885
[8627.287043] Humanoid.Jump = true
[8627.287300] >>> AUTO RELEASE | JumpHeldDown=false
[8627.287345] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 18.427885 -> 18.011141 | DeltaVy=-0.416744 | CanJump=true | JumpHeld=false
[8627.287366] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=18.011141
[8627.302755] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8627.302957] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=false | Vy=17.177919 | CanJump=true | JumpHeld=false | HumJump=false
[8628.020652] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-18.655418 | CanJump=true | JumpHeld=false | HumJump=false
[8628.061541] >>> GROUND AUTO JUMP #85 | Hum=Enum.HumanoidStateType.Running
[8628.061587] ==================================================
[8628.061600] ORIGINAL JumpReact | REASON=GROUND
[8628.061617] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-20.322090
[8628.061635] Humanoid.Jump = true
[8628.061822] >>> AUTO RELEASE | JumpHeldDown=false
[8628.061847] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -20.322090 -> -10.159818 | DeltaVy=10.162272 | CanJump=true | JumpHeld=false
[8628.061864] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-10.159818
[8628.061880] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-10.159818 | CanJump=true | JumpHeld=false | HumJump=true
[8628.086424] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8628.701896] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.554476 | CanJump=true | JumpHeld=false | HumJump=false
[8628.752256] >>> GROUND AUTO JUMP #86 | Hum=Enum.HumanoidStateType.Running
[8628.752351] ==================================================
[8628.752374] ORIGINAL JumpReact | REASON=GROUND
[8628.752410] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.429476
[8628.752444] Humanoid.Jump = true
[8628.752885] >>> AUTO RELEASE | JumpHeldDown=false
[8628.752951] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -16.429476 -> -4.053705 | DeltaVy=12.375771 | CanJump=true | JumpHeld=false
[8628.752979] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-4.053705
[8628.753006] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-4.053705 | CanJump=true | JumpHeld=false | HumJump=true
[8628.784604] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8629.401816] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.971144 | CanJump=true | JumpHeld=false | HumJump=false
[8629.451806] >>> GROUND AUTO JUMP #87 | Hum=Enum.HumanoidStateType.Running
[8629.451889] ==================================================
[8629.451917] ORIGINAL JumpReact | REASON=GROUND
[8629.451941] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.054480
[8629.451968] Humanoid.Jump = true
[8629.452364] >>> AUTO RELEASE | JumpHeldDown=false
[8629.452421] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -17.054480 -> -8.693322 | DeltaVy=8.361157 | CanJump=true | JumpHeld=false
[8629.452448] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-8.693322
[8629.452470] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-8.693322 | CanJump=true | JumpHeld=false | HumJump=true
[8629.484773] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8629.986769] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-9.137817 | CanJump=true | JumpHeld=false | HumJump=false
[8630.037900] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-11.637814 | CanJump=true | JumpHeld=false | HumJump=false
[8630.152029] >>> GROUND AUTO JUMP #88 | Hum=Enum.HumanoidStateType.Running
[8630.152085] ==================================================
[8630.152103] ORIGINAL JumpReact | REASON=GROUND
[8630.152123] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.846144
[8630.152146] Humanoid.Jump = true
[8630.152347] >>> AUTO RELEASE | JumpHeldDown=false
[8630.152370] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -16.846144 -> -11.473555 | DeltaVy=5.372589 | CanJump=true | JumpHeld=false
[8630.152387] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-11.473555
[8630.161130] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112175 | CanJump=true | JumpHeld=false | HumJump=false
[8630.168879] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8630.813328] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-15.387810 | CanJump=true | JumpHeld=false | HumJump=false
[8630.853835] >>> GROUND AUTO JUMP #89 | Hum=Enum.HumanoidStateType.Landed
[8630.853914] ==================================================
[8630.853951] ORIGINAL JumpReact | REASON=GROUND
[8630.853975] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.054480
[8630.853998] Humanoid.Jump = true
[8630.854220] >>> AUTO RELEASE | JumpHeldDown=false
[8630.854245] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -17.054480 -> -17.471148 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8630.854258] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.471148
[8630.863024] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112175 | CanJump=true | JumpHeld=false | HumJump=false
[8630.878336] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8631.493155] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.346145 | CanJump=true | JumpHeld=false | HumJump=false
[8631.535008] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-16.429478 | CanJump=true | JumpHeld=false | HumJump=false
[8631.545065] >>> GROUND AUTO JUMP #90 | Hum=Enum.HumanoidStateType.Running
[8631.545172] ==================================================
[8631.545211] ORIGINAL JumpReact | REASON=GROUND
[8631.545241] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.429478
[8631.545270] Humanoid.Jump = true
[8631.545746] >>> AUTO RELEASE | JumpHeldDown=false
[8631.545810] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -16.429478 -> -9.048606 | DeltaVy=7.380872 | CanJump=true | JumpHeld=false
[8631.545838] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-9.048606
[8631.568982] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8631.569636] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=false | Vy=16.487173 | CanJump=true | JumpHeld=false | HumJump=false
[8631.610663] >>> GROUND AUTO JUMP #91 | Hum=Enum.HumanoidStateType.Freefall
[8631.610744] ==================================================
[8631.610767] ORIGINAL JumpReact | REASON=GROUND
[8631.610792] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=14.820507
[8631.610819] Humanoid.Jump = true
[8631.611132] >>> AUTO RELEASE | JumpHeldDown=false
[8631.611166] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 14.820507 -> 14.403841 | DeltaVy=-0.416666 | CanJump=true | JumpHeld=false
[8631.611188] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=14.403841
[8631.620744] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112175 | CanJump=true | JumpHeld=false | HumJump=false
[8631.654586] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8632.334481] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-18.512817 | CanJump=true | JumpHeld=false | HumJump=false
[8632.368628] >>> GROUND AUTO JUMP #92 | Hum=Enum.HumanoidStateType.Landed
[8632.368703] ==================================================
[8632.368725] ORIGINAL JumpReact | REASON=GROUND
[8632.368748] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-19.971155
[8632.368772] Humanoid.Jump = true
[8632.369052] >>> AUTO RELEASE | JumpHeldDown=false
[8632.369084] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -19.971155 -> -10.868661 | DeltaVy=9.102494 | CanJump=true | JumpHeld=false
[8632.369105] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-10.868661
[8632.378542] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112177 | CanJump=true | JumpHeld=false | HumJump=false
[8632.402063] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8633.018009] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.762809 | CanJump=true | JumpHeld=false | HumJump=false
[8633.027367] >>> GROUND AUTO JUMP #93 | Hum=Enum.HumanoidStateType.Landed
[8633.027432] ==================================================
[8633.027449] ORIGINAL JumpReact | REASON=GROUND
[8633.027467] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-14.762809
[8633.027487] Humanoid.Jump = true
[8633.027719] >>> AUTO RELEASE | JumpHeldDown=false
[8633.027748] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -14.762809 -> -15.387808 | DeltaVy=-0.624999 | CanJump=true | JumpHeld=false
[8633.027768] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-15.387808
[8633.042752] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=true | Vy=16.903841 | CanJump=true | JumpHeld=false | HumJump=false
[8633.093272] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8633.719333] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-17.054480 | CanJump=true | JumpHeld=false | HumJump=false
[8633.762155] >>> GROUND AUTO JUMP #94 | Hum=Enum.HumanoidStateType.Landed
[8633.762216] ==================================================
[8633.762231] ORIGINAL JumpReact | REASON=GROUND
[8633.762250] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-18.721151
[8633.762266] Humanoid.Jump = true
[8633.762460] >>> AUTO RELEASE | JumpHeldDown=false
[8633.762490] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -18.721151 -> -9.926168 | DeltaVy=8.794983 | CanJump=true | JumpHeld=false
[8633.762506] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-9.926168
[8633.771692] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112177 | CanJump=true | JumpHeld=false | HumJump=false
[8633.786713] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8634.410019] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.971142 | CanJump=true | JumpHeld=false | HumJump=false
[8634.455163] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-17.054478 | CanJump=true | JumpHeld=false | HumJump=false
[8634.464281] >>> GROUND AUTO JUMP #95 | Hum=Enum.HumanoidStateType.Running
[8634.464399] ==================================================
[8634.464436] ORIGINAL JumpReact | REASON=GROUND
[8634.464461] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.054478
[8634.464490] Humanoid.Jump = true
[8634.464808] >>> AUTO RELEASE | JumpHeldDown=false
[8634.464832] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -17.054478 -> -3.694613 | DeltaVy=13.359864 | CanJump=true | JumpHeld=false
[8634.464847] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-3.694613
[8634.488548] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=true | Vy=16.487175 | CanJump=true | JumpHeld=false | HumJump=false
[8634.495940] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8634.512724] >>> GROUND AUTO JUMP #96 | Hum=Enum.HumanoidStateType.Freefall
[8634.512823] ==================================================
[8634.512850] ORIGINAL JumpReact | REASON=GROUND
[8634.512871] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=15.653841
[8634.512894] Humanoid.Jump = true
[8634.513270] >>> AUTO RELEASE | JumpHeldDown=false
[8634.513308] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 15.653841 -> 40.199532 | DeltaVy=24.545691 | CanJump=true | JumpHeld=false
[8634.513339] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=40.199532
[8634.519863] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8634.520236] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=false | Vy=39.783005 | CanJump=true | JumpHeld=false | HumJump=false
[8634.529251] >>> GROUND AUTO JUMP #97 | Hum=Enum.HumanoidStateType.Freefall
[8634.529312] ==================================================
[8634.529328] ORIGINAL JumpReact | REASON=GROUND
[8634.529347] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=39.782986
[8634.529364] Humanoid.Jump = true
[8634.529663] >>> AUTO RELEASE | JumpHeldDown=false
[8634.529688] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 39.782986 -> 39.366264 | DeltaVy=-0.416721 | CanJump=true | JumpHeld=false
[8634.529704] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=39.366264
[8634.537504] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8634.544236] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=false | Vy=38.532909 | CanJump=true | JumpHeld=false | HumJump=false
[8636.126600] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-40.425419 | CanJump=true | JumpHeld=false | HumJump=false
[8636.144266] >>> GROUND AUTO JUMP #98 | Hum=Enum.HumanoidStateType.Landed
[8636.144377] ==================================================
[8636.144402] ORIGINAL JumpReact | REASON=GROUND
[8636.144429] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-41.050415
[8636.144456] Humanoid.Jump = true
[8636.144929] >>> AUTO RELEASE | JumpHeldDown=false
[8636.144979] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -41.050415 -> -20.578035 | DeltaVy=20.472380 | CanJump=true | JumpHeld=false
[8636.145003] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-20.578035
[8636.153425] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112179 | CanJump=true | JumpHeld=false | HumJump=false
[8636.176745] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8636.784414] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-14.346141 | CanJump=true | JumpHeld=false | HumJump=false
[8636.826116] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-16.429474 | CanJump=true | JumpHeld=false | HumJump=false
[8636.835926] >>> GROUND AUTO JUMP #99 | Hum=Enum.HumanoidStateType.Running
[8636.835989] ==================================================
[8636.836011] ORIGINAL JumpReact | REASON=GROUND
[8636.836046] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.429474
[8636.836078] Humanoid.Jump = true
[8636.836583] >>> AUTO RELEASE | JumpHeldDown=false
[8636.836616] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -16.429474 -> -4.601643 | DeltaVy=11.827831 | CanJump=true | JumpHeld=false
[8636.836638] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-4.601643
[8636.852411] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=true | Vy=16.695507 | CanJump=true | JumpHeld=false | HumJump=false
[8636.859768] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8636.918507] >>> GROUND AUTO JUMP #100 | Hum=Enum.HumanoidStateType.Freefall
[8636.918600] ==================================================
[8636.918626] ORIGINAL JumpReact | REASON=GROUND
[8636.918652] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=13.987175
[8636.918675] Humanoid.Jump = true
[8636.918959] >>> AUTO RELEASE | JumpHeldDown=false
[8636.919002] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 13.987175 -> 13.362176 | DeltaVy=-0.624999 | CanJump=true | JumpHeld=false
[8636.919027] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=13.362176
[8636.928126] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112175 | CanJump=true | JumpHeld=false | HumJump=false
[8636.951474] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8637.651572] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-18.929485 | CanJump=true | JumpHeld=false | HumJump=false
[8637.684990] >>> GROUND AUTO JUMP #101 | Hum=Enum.HumanoidStateType.Landed
[8637.685065] ==================================================
[8637.685086] ORIGINAL JumpReact | REASON=GROUND
[8637.685109] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-20.179489
[8637.685134] Humanoid.Jump = true
[8637.685359] >>> AUTO RELEASE | JumpHeldDown=false
[8637.685397] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -20.179489 -> -10.879303 | DeltaVy=9.300186 | CanJump=true | JumpHeld=false
[8637.685419] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-10.879303
[8637.694062] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112177 | CanJump=true | JumpHeld=false | HumJump=false
[8637.717924] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8638.226284] >>> GROUND AUTO JUMP #102 | Hum=Enum.HumanoidStateType.Freefall
[8638.226387] ==================================================
[8638.226405] ORIGINAL JumpReact | REASON=GROUND
[8638.226425] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=1.648271
[8638.226445] Humanoid.Jump = true
[8638.226753] >>> AUTO RELEASE | JumpHeldDown=false
[8638.226818] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 1.648271 -> 5.608125 | DeltaVy=3.959854 | CanJump=true | JumpHeld=false
[8638.226857] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=5.608125
[8638.239103] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=24.853767 | CanJump=true | JumpHeld=false | HumJump=false
[8638.245196] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8638.278485] >>> GROUND AUTO JUMP #103 | Hum=Enum.HumanoidStateType.Freefall
[8638.278561] ==================================================
[8638.278584] ORIGINAL JumpReact | REASON=GROUND
[8638.278602] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=24.671894
[8638.278623] Humanoid.Jump = true
[8638.278884] >>> AUTO RELEASE | JumpHeldDown=false
[8638.278924] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 24.671894 -> 24.255238 | DeltaVy=-0.416656 | CanJump=true | JumpHeld=false
[8638.278943] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=24.255238
[8638.288039] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8638.288837] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=false | Vy=23.838577 | CanJump=true | JumpHeld=false | HumJump=false
[8638.718712] >>> GROUND AUTO JUMP #104 | Hum=Enum.HumanoidStateType.Freefall
[8638.718797] ==================================================
[8638.718822] ORIGINAL JumpReact | REASON=GROUND
[8638.718846] BEFORE | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=2.588567
[8638.718867] Humanoid.Jump = true
[8638.719199] >>> AUTO RELEASE | JumpHeldDown=false
[8638.719274] JumpReact RETURNED | State Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Freefall | Vy 2.588567 -> 2.171901 | DeltaVy=-0.416667 | CanJump=true | JumpHeld=false
[8638.719310] AFTER | Hum=Enum.HumanoidStateType.Freefall | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=2.171901
[8638.728329] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112175 | CanJump=true | JumpHeld=false | HumJump=false
[8638.809976] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8639.286133] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-10.804483 | CanJump=true | JumpHeld=false | HumJump=false
[8639.335970] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=false | Vy=-13.304480 | CanJump=true | JumpHeld=false | HumJump=false
[8639.352963] >>> GROUND AUTO JUMP #105 | Hum=Enum.HumanoidStateType.Running
[8639.353029] ==================================================
[8639.353049] ORIGINAL JumpReact | REASON=GROUND
[8639.353071] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-13.721146
[8639.353092] Humanoid.Jump = true
[8639.353339] >>> AUTO RELEASE | JumpHeldDown=false
[8639.353380] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -13.721146 -> -14.137812 | DeltaVy=-0.416666 | CanJump=true | JumpHeld=false
[8639.353401] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-14.137812
[8639.363058] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112175 | CanJump=true | JumpHeld=false | HumJump=false
[8639.376316] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8640.010654] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-15.387810 | CanJump=true | JumpHeld=false | HumJump=false
[8640.045043] >>> GROUND AUTO JUMP #106 | Hum=Enum.HumanoidStateType.Landed
[8640.045121] ==================================================
[8640.045138] ORIGINAL JumpReact | REASON=GROUND
[8640.045159] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.637812
[8640.045193] Humanoid.Jump = true
[8640.045565] >>> AUTO RELEASE | JumpHeldDown=false
[8640.045621] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -16.637812 -> -17.054480 | DeltaVy=-0.416668 | CanJump=true | JumpHeld=false
[8640.045652] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.054480
[8640.055378] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112179 | CanJump=true | JumpHeld=false | HumJump=false
[8640.061459] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8640.710069] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-15.596139 | CanJump=true | JumpHeld=false | HumJump=false
[8640.752465] >>> GROUND AUTO JUMP #107 | Hum=Enum.HumanoidStateType.Running
[8640.752546] ==================================================
[8640.752571] ORIGINAL JumpReact | REASON=GROUND
[8640.752595] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-17.262810
[8640.752623] Humanoid.Jump = true
[8640.752982] >>> AUTO RELEASE | JumpHeldDown=false
[8640.753044] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -17.262810 -> -17.887812 | DeltaVy=-0.625002 | CanJump=true | JumpHeld=false
[8640.753072] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-17.887812
[8640.753095] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-17.887812 | CanJump=true | JumpHeld=false | HumJump=true
[8640.776730] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8641.203597] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-3.174013 | CanJump=true | JumpHeld=false | HumJump=false
[8641.210271] >>> GROUND AUTO JUMP #108 | Hum=Enum.HumanoidStateType.Landed
[8641.210320] ==================================================
[8641.210344] ORIGINAL JumpReact | REASON=GROUND
[8641.210361] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-3.174027
[8641.210378] Humanoid.Jump = true
[8641.210595] >>> AUTO RELEASE | JumpHeldDown=false
[8641.210613] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -3.174027 -> 23.961542 | DeltaVy=27.135570 | CanJump=true | JumpHeld=false
[8641.210626] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=23.961542
[8641.226408] STATE: Enum.HumanoidStateType.Jumping -> Enum.HumanoidStateType.Freefall | Grounded=true | Vy=42.739758 | CanJump=true | JumpHeld=false | HumJump=false
[8641.258536] STATE: Enum.HumanoidStateType.Climbing -> Enum.HumanoidStateType.Running | Grounded=true | Vy=12.746540 | CanJump=true | JumpHeld=false | HumJump=false
[8641.879457] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8642.019069] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Freefall | Grounded=false | Vy=17.075642 | CanJump=true | JumpHeld=false | HumJump=false
[8642.936955] >>> GROUND AUTO JUMP #109 | Hum=Enum.HumanoidStateType.Landed
[8642.937043] ==================================================
[8642.937077] ORIGINAL JumpReact | REASON=GROUND
[8642.937114] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-28.341047
[8642.937169] Humanoid.Jump = true
[8642.937494] >>> AUTO RELEASE | JumpHeldDown=false
[8642.937542] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -28.341047 -> -13.365540 | DeltaVy=14.975508 | CanJump=true | JumpHeld=false
[8642.937564] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-13.365540
[8642.937581] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=true | Vy=-13.365540 | CanJump=true | JumpHeld=false | HumJump=true
[8642.970520] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Climbing | Grounded=true | Vy=23.134050 | CanJump=true | JumpHeld=false | HumJump=false
[8642.994345] STATE: Enum.HumanoidStateType.Climbing -> Enum.HumanoidStateType.Running | Grounded=true | Vy=16.267920 | CanJump=true | JumpHeld=false | HumJump=false
[8643.961303] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8643.993734] >>> GROUND AUTO JUMP #110 | Hum=Enum.HumanoidStateType.Running
[8643.993768] ==================================================
[8643.993779] ORIGINAL JumpReact | REASON=GROUND
[8643.993796] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-0.379887
[8643.993814] Humanoid.Jump = true
[8643.994069] >>> AUTO RELEASE | JumpHeldDown=false
[8643.994125] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -0.379887 -> -1.119332 | DeltaVy=-0.739445 | CanJump=true | JumpHeld=false
[8643.994149] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-1.119332
[8644.002403] STATE: Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=17.112175 | CanJump=true | JumpHeld=false | HumJump=false
[8644.008788] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8645.200820] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-42.679459 | CanJump=true | JumpHeld=false | HumJump=false
[8645.217943] >>> GROUND AUTO JUMP #111 | Hum=Enum.HumanoidStateType.Landed
[8645.218010] ==================================================
[8645.218026] ORIGINAL JumpReact | REASON=GROUND
[8645.218047] BEFORE | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-43.304455
[8645.218079] Humanoid.Jump = true
[8645.218288] >>> AUTO RELEASE | JumpHeldDown=false
[8645.218309] JumpReact RETURNED | State Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Landed | Vy -43.304455 -> -22.093061 | DeltaVy=21.211393 | CanJump=true | JumpHeld=false
[8645.218326] AFTER | Hum=Enum.HumanoidStateType.Landed | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-22.093061
[8645.228284] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Jumping | Grounded=true | Vy=16.903845 | CanJump=true | JumpHeld=false | HumJump=false
[8645.251524] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8645.871186] STATE: Enum.HumanoidStateType.Freefall -> Enum.HumanoidStateType.Landed | Grounded=false | Vy=-15.179473 | CanJump=true | JumpHeld=false | HumJump=false
[8645.909260] >>> GROUND AUTO JUMP #112 | Hum=Enum.HumanoidStateType.Running
[8645.909318] ==================================================
[8645.909335] ORIGINAL JumpReact | REASON=GROUND
[8645.909353] BEFORE | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=false | JumpEnabled=true | Vy=-16.637808
[8645.909373] Humanoid.Jump = true
[8645.909585] >>> AUTO RELEASE | JumpHeldDown=false
[8645.909603] JumpReact RETURNED | State Enum.HumanoidStateType.Running -> Enum.HumanoidStateType.Running | Vy -16.637808 -> -8.649490 | DeltaVy=7.988317 | CanJump=true | JumpHeld=false
[8645.909620] AFTER | Hum=Enum.HumanoidStateType.Running | Move=Move | Reg=Move | Climb=nil | Ending=nil | Grounded=true | JumpAmount=0 | CanJump=true | JumpHeld=false | HumJump=true | JumpEnabled=true | Vy=-8.649490
[8645.909637] STATE: Enum.HumanoidStateType.Landed -> Enum.HumanoidStateType.Running | Grounded=true | Vy=-8.649490 | CanJump=true | JumpHeld=false | HumJump=true
[8645.933873] >>> LEFT GROUND | GROUND JUMP RE-ARMED
[8646.423987] ===== F6 FULL STOP =====

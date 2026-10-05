==================================================
DeadEye ClimbAlign Physics Trace v1.11
==================================================
CHARACTER PATH:
Players.DEN919191.Character

MOVEMENT SOURCE PATH:
ReplicatedStorage.Objects.Game.Character.Client.Movement

CONSTRAINT SOURCE PATH:
ReplicatedStorage.Objects.Game.Character.Client.Movement.Constraints

CLIMB SOURCE PATH:
ReplicatedStorage.Objects.Game.Character.Client.Movement.MoveFunction.Functions.Climb

WARNING:
Live AlignPosition 'ClimbAlign' not found at startup.
Будем продолжать поиск на каждом кадре.

LIVE MOVEMENT INSTANCE FOUND
FULL SOURCE PATH = ReplicatedStorage.Objects.Game.Character.Client.Movement


F6 = STOP + COPY

ЦЕЛЬ ТЕСТА:
поймать момент перед самым большим Vy,
и увидеть состояние ClimbAlign + DataRegistry.

Повтори тот же баг.


========== DATAREGISTRY STATE CHANGE ==========
Time      = 8476.700811
State     = Idle
Climbing  = nil
Humanoid  = Running
Position  = (159.519684, 2.749961, -698.984497)
Velocity  = (-0.000000, 0.000020, -0.000000)

========== DATAREGISTRY STATE CHANGE ==========
Time      = 8477.671504
State     = Move
Climbing  = nil
Humanoid  = Running
Position  = (159.510559, 2.749961, -698.912598)
Velocity  = (-0.707596, 0.000020, 5.583876)

========== HUMANOID STATE CHANGED ==========
Time     = 8478.612600
From     = Running
To       = Jumping
Position = (156.843506, 2.749961, -675.402283)
Velocity = (8.761143, 0.000020, 38.517429)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Move
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = true
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (932.728088, 0.000000, 3469.333252)
LookCFrame = pos=(154.921890, 8.202681, -679.977600) look=(-0.013861, -0.591601, 0.806112)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (0.985991, -0.591601, 0.823305)
Speed = 39.9
RelativeMoveDirection = (-0.322317, -0.000000, -0.946632)
----------------------------------------------
============================================

==================================================
VERTICAL EVENT #1
==================================================
Time       = 8478.614869
Humanoid   = Jumping
Position   = (156.929871, 2.893430, -675.080994)
Prev Vy    = 0.000020
Current Vy = 17.112177
Delta Vy   = 17.112157
DataRegistry.State    = Move
DataRegistry.Climbing = nil
DataRegistry.Velocity = (932.728088, 0.000000, 3469.333252)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Move
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = true
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (932.728088, 0.000000, 3469.333252)
LookCFrame = pos=(154.921890, 8.202681, -679.977600) look=(-0.013861, -0.591601, 0.806112)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (0.985991, -0.591601, 0.823305)
Speed = 39.9
RelativeMoveDirection = (-0.322317, -0.000000, -0.946632)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.345394 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.810638, 2.749961, -685.502991)
age=+0.337296 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.781616, 2.749961, -685.275208)
age=+0.329101 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.752441, 2.749961, -685.046326)
age=+0.320988 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.723114, 2.749961, -684.816345)
age=+0.311828 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.693604, 2.749961, -684.585266)
age=+0.304056 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.663940, 2.749961, -684.353210)
age=+0.296209 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.634125, 2.749961, -684.120056)
age=+0.287296 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.604126, 2.749961, -683.885803)
age=+0.278860 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.573975, 2.749961, -683.650574)
age=+0.270689 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.543671, 2.749961, -683.414368)
age=+0.262341 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.513214, 2.749961, -683.177063)
age=+0.253301 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.482605, 2.749961, -682.938660)
age=+0.245116 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.451843, 2.749961, -682.699280)
age=+0.236993 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.420929, 2.749961, -682.458801)
age=+0.228339 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.389862, 2.749961, -682.217224)
age=+0.220599 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.358643, 2.749961, -681.974670)
age=+0.212169 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.327271, 2.749961, -681.731018)
age=+0.203082 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.295746, 2.749961, -681.486389)
age=+0.194879 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.264069, 2.749961, -681.240662)
age=+0.187198 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.232239, 2.749961, -680.993958)
age=+0.178154 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.200256, 2.749961, -680.746155)
age=+0.170145 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.168121, 2.749961, -680.497253)
age=+0.161961 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.135834, 2.749961, -680.247375)
age=+0.153582 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.103424, 2.749961, -679.996399)
age=+0.144621 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.070831, 2.749961, -679.744324)
age=+0.136637 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.038116, 2.749961, -679.491272)
age=+0.128775 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(157.005280, 2.749961, -679.237122)
age=+0.120612 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(156.972321, 2.749961, -678.981995)
age=+0.111556 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(156.939270, 2.749961, -678.725769)
age=+0.103575 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(156.906097, 2.749961, -678.468445)
age=+0.095758 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(156.872833, 2.749961, -678.210022)
age=+0.086428 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(156.839508, 2.749961, -677.950623)
age=+0.078412 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(156.806122, 2.749961, -677.690125)
age=+0.070823 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(156.772705, 2.749961, -677.428528)
age=+0.061718 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(156.739288, 2.749961, -677.165833)
age=+0.053169 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(156.705902, 2.749961, -676.902161)
age=+0.044439 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(156.672577, 2.749961, -676.637390)
age=+0.035405 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(156.672943, 2.749961, -676.351990)
age=+0.028705 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(156.705963, 2.749961, -676.046570)
age=+0.019986 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(156.770508, 2.749961, -675.723206)
age=+0.012109 | Heartbeat   | HumanoidState=Running   | Vy=+0.000020 | Pos=(156.843506, 2.749961, -675.402283)
age=+0.000334 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112177 | Pos=(156.929871, 2.893430, -675.080994)
-----------------------------------------------
==================================================


========== HUMANOID STATE CHANGED ==========
Time     = 8478.631855
From     = Jumping
To       = Freefall
Position = (156.929871, 2.893430, -675.080994)
Velocity = (10.363643, 17.112177, 38.548149)
============================================

========== DATAREGISTRY STATE CHANGE ==========
Time      = 8478.642722
State     = Air
Climbing  = nil
Humanoid  = Freefall
Position  = (157.254150, 3.368230, -673.976990)
Velocity  = (11.118416, 15.653841, 37.855492)

========== HUMANOID STATE CHANGED ==========
Time     = 8479.255940
From     = Freefall
To       = Landed
Position = (149.361938, 3.637397, -654.115051)
Velocity = (-39.525227, -14.554476, 12.547839)
============================================

========== HUMANOID STATE CHANGED ==========
Time     = 8479.302413
From     = Landed
To       = Running
Position = (147.342072, 2.841965, -653.638306)
Velocity = (-41.224670, -17.054478, 6.175201)
============================================

========== DATAREGISTRY STATE CHANGE ==========
Time      = 8479.303912
State     = Move
Climbing  = nil
Humanoid  = Running
Position  = (146.980774, 2.720062, -653.625610)
Velocity  = (-43.354084, -11.993769, 1.526246)

========== HUMANOID STATE CHANGED ==========
Time     = 8479.312401
From     = Running
To       = Jumping
Position = (146.980774, 2.720062, -653.625610)
Velocity = (-43.354084, -11.993769, 1.526246)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Move
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = true
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4070.080078, 0.000000, -306.112732)
LookCFrame = pos=(150.142166, 9.222164, -655.913513) look=(-0.621204, -0.781714, 0.055035)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.709453, -0.781714, -0.941063)
Speed = 45.3
RelativeMoveDirection = (0.220323, 0.000000, -0.975427)
----------------------------------------------
============================================

==================================================
VERTICAL EVENT #2
==================================================
Time       = 8479.315554
Humanoid   = Jumping
Position   = (146.603912, 2.863532, -653.653931)
Prev Vy    = -11.993769
Current Vy = 17.112175
Delta Vy   = 29.105944
DataRegistry.State    = Move
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4070.080078, 0.000000, -306.112732)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Move
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = true
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4070.080078, 0.000000, -306.112732)
LookCFrame = pos=(150.142166, 9.222164, -655.913513) look=(-0.621204, -0.781714, 0.055035)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.709453, -0.781714, -0.941063)
Speed = 45.3
RelativeMoveDirection = (0.220323, 0.000000, -0.975427)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.344660 | Heartbeat   | HumanoidState=Freefall  | Vy=-0.804483 | Pos=(157.605118, 5.777900, -661.158630)
age=+0.335665 | Heartbeat   | HumanoidState=Freefall  | Vy=-1.221150 | Pos=(157.477737, 5.768592, -660.847595)
age=+0.327770 | Heartbeat   | HumanoidState=Freefall  | Vy=-1.637817 | Pos=(157.345993, 5.755812, -660.538147)
age=+0.319352 | Heartbeat   | HumanoidState=Freefall  | Vy=-2.054484 | Pos=(157.197708, 5.739559, -660.235901)
age=+0.311687 | Heartbeat   | HumanoidState=Freefall  | Vy=-2.471150 | Pos=(157.040970, 5.719834, -659.937561)
age=+0.302559 | Heartbeat   | HumanoidState=Freefall  | Vy=-2.887817 | Pos=(156.880051, 5.696637, -659.641174)
age=+0.294753 | Heartbeat   | HumanoidState=Freefall  | Vy=-3.304483 | Pos=(156.712387, 5.669968, -659.348206)
age=+0.285699 | Heartbeat   | HumanoidState=Freefall  | Vy=-3.721150 | Pos=(156.537033, 5.639826, -659.059387)
age=+0.277719 | Heartbeat   | HumanoidState=Freefall  | Vy=-4.137816 | Pos=(156.352585, 5.606213, -658.775940)
age=+0.269826 | Heartbeat   | HumanoidState=Freefall  | Vy=-4.554483 | Pos=(156.158737, 5.569127, -658.498352)
age=+0.261811 | Heartbeat   | HumanoidState=Freefall  | Vy=-4.971150 | Pos=(155.954727, 5.528568, -658.227600)
age=+0.254823 | Heartbeat   | HumanoidState=Freefall  | Vy=-5.387817 | Pos=(155.740799, 5.484538, -657.964172)
age=+0.247039 | Heartbeat   | HumanoidState=Freefall  | Vy=-5.804484 | Pos=(155.509384, 5.437036, -657.715393)
age=+0.238018 | Heartbeat   | HumanoidState=Freefall  | Vy=-6.221151 | Pos=(155.277969, 5.386061, -657.466614)
age=+0.229786 | Heartbeat   | HumanoidState=Freefall  | Vy=-6.637818 | Pos=(155.037857, 5.331614, -657.225769)
age=+0.221350 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.054485 | Pos=(154.786484, 5.273694, -656.996033)
age=+0.213157 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.471152 | Pos=(154.523605, 5.212303, -656.778870)
age=+0.205109 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.887819 | Pos=(154.254196, 5.147439, -656.569397)
age=+0.196328 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.304485 | Pos=(153.979202, 5.079103, -656.366760)
age=+0.187753 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.721151 | Pos=(153.693100, 5.007295, -656.179382)
age=+0.179333 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.137817 | Pos=(153.406998, 4.932014, -655.992004)
age=+0.171526 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.554483 | Pos=(153.115555, 4.853262, -655.812439)
age=+0.162384 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.971149 | Pos=(152.819595, 4.771037, -655.639709)
age=+0.154263 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.387815 | Pos=(152.520187, 4.685340, -655.472595)
age=+0.146257 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.804482 | Pos=(152.217422, 4.596170, -655.310974)
age=+0.137551 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.221148 | Pos=(151.912003, 4.503529, -655.153992)
age=+0.129444 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.637814 | Pos=(151.603989, 4.407415, -655.001648)
age=+0.121561 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.054480 | Pos=(151.293167, 4.307829, -654.854553)
age=+0.112853 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.103472 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.096004 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.087810 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.072714 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.068822 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.058389 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.051921 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.045442 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.037905 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.029135 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.020804 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.011978 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.000345 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
-----------------------------------------------
==================================================


========== HUMANOID STATE CHANGED ==========
Time     = 8479.329293
From     = Jumping
To       = Freefall
Position = (146.603912, 2.863532, -653.653931)
Velocity = (-45.223114, 17.112175, -3.401248)
============================================

========== HUMANOID STATE CHANGED ==========
Time     = 8479.340213
From     = Freefall
To       = Climbing
Position = (145.653854, 3.314197, -653.921936)
Velocity = (-47.206211, 23.025438, -15.052860)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
#1 | Workspace.Map.Parts.ImmovableProps.Model.Bench.Part | size=(0.167341, 1.840754, 0.167341) | pos=(145.002609, 0.920490, -654.778625) | CanCollide=true | Transparency=0.000000
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Move
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = true
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4236.339844, 0.000000, -1517.323364)
LookCFrame = pos=(148.721527, 9.769936, -655.622192) look=(-0.616795, -0.784936, -0.058643)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.522146, -0.784936, -1.054153)
Speed = 49.9
RelativeMoveDirection = (0.327802, 0.276326, -0.903432)
----------------------------------------------
============================================

========== HUMANOID STATE CHANGED ==========
Time     = 8479.346293
From     = Climbing
To       = Jumping
Position = (145.696198, 3.363925, -653.992249)
Velocity = (-47.037529, 11.953101, -16.872265)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
#1 | Workspace.Map.Parts.ImmovableProps.Model.Bench.Part | size=(0.167341, 1.840754, 0.167341) | pos=(145.002609, 0.920490, -654.778625) | CanCollide=true | Transparency=0.000000
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Move
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = true
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4173.756836, 0.000000, -1548.322632)
LookCFrame = pos=(148.986053, 9.868410, -655.693787) look=(-0.616795, -0.784936, -0.058643)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.522146, -0.784936, -1.054153)
Speed = 49.4
RelativeMoveDirection = (0.265117, 0.136809, -0.954461)
----------------------------------------------
============================================

==================================================
VERTICAL EVENT #3
==================================================
Time       = 8479.348841
Humanoid   = Jumping
Position   = (145.733032, 3.540446, -654.063965)
Prev Vy    = 11.952947
Current Vy = 42.383430
Delta Vy   = 30.430484
DataRegistry.State    = Move
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4173.756836, 0.000000, -1548.322632)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
#1 | Workspace.Map.Parts.ImmovableProps.Model.Bench.Part | size=(11.156098, 0.223122, 0.167341) | pos=(145.002579, 1.729153, -652.910034) | CanCollide=true | Transparency=0.000000
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Move
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = true
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4173.756836, 0.000000, -1548.322632)
LookCFrame = pos=(148.986053, 9.868410, -655.693787) look=(-0.616795, -0.784936, -0.058643)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.522146, -0.784936, -1.054153)
Speed = 49.4
RelativeMoveDirection = (0.265117, 0.136809, -0.954461)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.344933 | Heartbeat   | HumanoidState=Freefall  | Vy=-2.471150 | Pos=(157.040970, 5.719834, -659.937561)
age=+0.335806 | Heartbeat   | HumanoidState=Freefall  | Vy=-2.887817 | Pos=(156.880051, 5.696637, -659.641174)
age=+0.327999 | Heartbeat   | HumanoidState=Freefall  | Vy=-3.304483 | Pos=(156.712387, 5.669968, -659.348206)
age=+0.318945 | Heartbeat   | HumanoidState=Freefall  | Vy=-3.721150 | Pos=(156.537033, 5.639826, -659.059387)
age=+0.310965 | Heartbeat   | HumanoidState=Freefall  | Vy=-4.137816 | Pos=(156.352585, 5.606213, -658.775940)
age=+0.303072 | Heartbeat   | HumanoidState=Freefall  | Vy=-4.554483 | Pos=(156.158737, 5.569127, -658.498352)
age=+0.295057 | Heartbeat   | HumanoidState=Freefall  | Vy=-4.971150 | Pos=(155.954727, 5.528568, -658.227600)
age=+0.288069 | Heartbeat   | HumanoidState=Freefall  | Vy=-5.387817 | Pos=(155.740799, 5.484538, -657.964172)
age=+0.280285 | Heartbeat   | HumanoidState=Freefall  | Vy=-5.804484 | Pos=(155.509384, 5.437036, -657.715393)
age=+0.271264 | Heartbeat   | HumanoidState=Freefall  | Vy=-6.221151 | Pos=(155.277969, 5.386061, -657.466614)
age=+0.263032 | Heartbeat   | HumanoidState=Freefall  | Vy=-6.637818 | Pos=(155.037857, 5.331614, -657.225769)
age=+0.254596 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.054485 | Pos=(154.786484, 5.273694, -656.996033)
age=+0.246403 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.471152 | Pos=(154.523605, 5.212303, -656.778870)
age=+0.238355 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.887819 | Pos=(154.254196, 5.147439, -656.569397)
age=+0.229574 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.304485 | Pos=(153.979202, 5.079103, -656.366760)
age=+0.220999 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.721151 | Pos=(153.693100, 5.007295, -656.179382)
age=+0.212579 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.137817 | Pos=(153.406998, 4.932014, -655.992004)
age=+0.204772 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.554483 | Pos=(153.115555, 4.853262, -655.812439)
age=+0.195631 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.971149 | Pos=(152.819595, 4.771037, -655.639709)
age=+0.187509 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.387815 | Pos=(152.520187, 4.685340, -655.472595)
age=+0.179503 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.804482 | Pos=(152.217422, 4.596170, -655.310974)
age=+0.170797 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.221148 | Pos=(151.912003, 4.503529, -655.153992)
age=+0.162690 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.637814 | Pos=(151.603989, 4.407415, -655.001648)
age=+0.154808 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.054480 | Pos=(151.293167, 4.307829, -654.854553)
age=+0.146099 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.136719 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.129250 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.121056 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.105960 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.102068 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.091635 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.085167 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.078688 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.071152 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.062381 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.054051 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.045224 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.033591 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.017246 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.011620 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.007240 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.000283 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #4
==================================================
Time       = 8479.365757
Humanoid   = Jumping
Position   = (145.083099, 4.807478, -654.373047)
Prev Vy    = 42.383430
Current Vy = 69.650375
Delta Vy   = 27.266945
DataRegistry.State    = Move
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4093.236572, 0.000000, -1668.307007)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Move
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = true
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4093.236572, 0.000000, -1668.307007)
LookCFrame = pos=(149.062744, 10.044948, -655.682312) look=(-0.615196, -0.784936, -0.073544)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.496495, -0.784936, -1.066474)
Speed = 49.1
RelativeMoveDirection = (0.295365, 0.135973, -0.945659)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.344932 | Heartbeat   | HumanoidState=Freefall  | Vy=-3.304483 | Pos=(156.712387, 5.669968, -659.348206)
age=+0.335877 | Heartbeat   | HumanoidState=Freefall  | Vy=-3.721150 | Pos=(156.537033, 5.639826, -659.059387)
age=+0.327898 | Heartbeat   | HumanoidState=Freefall  | Vy=-4.137816 | Pos=(156.352585, 5.606213, -658.775940)
age=+0.320004 | Heartbeat   | HumanoidState=Freefall  | Vy=-4.554483 | Pos=(156.158737, 5.569127, -658.498352)
age=+0.311989 | Heartbeat   | HumanoidState=Freefall  | Vy=-4.971150 | Pos=(155.954727, 5.528568, -658.227600)
age=+0.305002 | Heartbeat   | HumanoidState=Freefall  | Vy=-5.387817 | Pos=(155.740799, 5.484538, -657.964172)
age=+0.297217 | Heartbeat   | HumanoidState=Freefall  | Vy=-5.804484 | Pos=(155.509384, 5.437036, -657.715393)
age=+0.288196 | Heartbeat   | HumanoidState=Freefall  | Vy=-6.221151 | Pos=(155.277969, 5.386061, -657.466614)
age=+0.279964 | Heartbeat   | HumanoidState=Freefall  | Vy=-6.637818 | Pos=(155.037857, 5.331614, -657.225769)
age=+0.271528 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.054485 | Pos=(154.786484, 5.273694, -656.996033)
age=+0.263336 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.471152 | Pos=(154.523605, 5.212303, -656.778870)
age=+0.255287 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.887819 | Pos=(154.254196, 5.147439, -656.569397)
age=+0.246506 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.304485 | Pos=(153.979202, 5.079103, -656.366760)
age=+0.237931 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.721151 | Pos=(153.693100, 5.007295, -656.179382)
age=+0.229511 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.137817 | Pos=(153.406998, 4.932014, -655.992004)
age=+0.221705 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.554483 | Pos=(153.115555, 4.853262, -655.812439)
age=+0.212563 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.971149 | Pos=(152.819595, 4.771037, -655.639709)
age=+0.204441 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.387815 | Pos=(152.520187, 4.685340, -655.472595)
age=+0.196436 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.804482 | Pos=(152.217422, 4.596170, -655.310974)
age=+0.187729 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.221148 | Pos=(151.912003, 4.503529, -655.153992)
age=+0.179623 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.637814 | Pos=(151.603989, 4.407415, -655.001648)
age=+0.171740 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.054480 | Pos=(151.293167, 4.307829, -654.854553)
age=+0.163031 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.153651 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.146182 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.137988 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.122892 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.119000 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.108567 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.102099 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.095621 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.088084 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.079314 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.070983 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.062156 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.050523 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.034178 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.028552 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.024172 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.017215 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.000355 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
-----------------------------------------------
==================================================


========== DATAREGISTRY STATE CHANGE ==========
Time      = 8479.380527
State     = Air
Climbing  = nil
Humanoid  = Jumping
Position  = (144.325104, 5.990611, -654.682129)
Velocity  = (-45.486248, 71.306938, -18.538937)

==================================================
VERTICAL EVENT #5
==================================================
Time       = 8479.380600
Humanoid   = Jumping
Position   = (144.325104, 5.990611, -654.682129)
Prev Vy    = 69.650375
Current Vy = 71.306938
Delta Vy   = 1.656563
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4093.236572, 0.000000, -1668.307007)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4093.236572, 0.000000, -1668.307007)
LookCFrame = pos=(148.023468, 11.134250, -655.691711) look=(-0.602722, -0.786006, -0.137556)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.380218, -0.786006, -1.112488)
Speed = 49.1
RelativeMoveDirection = (0.293801, 0.482347, -0.825241)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.342743 | Heartbeat   | HumanoidState=Freefall  | Vy=-4.137816 | Pos=(156.352585, 5.606213, -658.775940)
age=+0.334849 | Heartbeat   | HumanoidState=Freefall  | Vy=-4.554483 | Pos=(156.158737, 5.569127, -658.498352)
age=+0.326835 | Heartbeat   | HumanoidState=Freefall  | Vy=-4.971150 | Pos=(155.954727, 5.528568, -658.227600)
age=+0.319847 | Heartbeat   | HumanoidState=Freefall  | Vy=-5.387817 | Pos=(155.740799, 5.484538, -657.964172)
age=+0.312063 | Heartbeat   | HumanoidState=Freefall  | Vy=-5.804484 | Pos=(155.509384, 5.437036, -657.715393)
age=+0.303042 | Heartbeat   | HumanoidState=Freefall  | Vy=-6.221151 | Pos=(155.277969, 5.386061, -657.466614)
age=+0.294810 | Heartbeat   | HumanoidState=Freefall  | Vy=-6.637818 | Pos=(155.037857, 5.331614, -657.225769)
age=+0.286374 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.054485 | Pos=(154.786484, 5.273694, -656.996033)
age=+0.278181 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.471152 | Pos=(154.523605, 5.212303, -656.778870)
age=+0.270133 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.887819 | Pos=(154.254196, 5.147439, -656.569397)
age=+0.261352 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.304485 | Pos=(153.979202, 5.079103, -656.366760)
age=+0.252777 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.721151 | Pos=(153.693100, 5.007295, -656.179382)
age=+0.244356 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.137817 | Pos=(153.406998, 4.932014, -655.992004)
age=+0.236550 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.554483 | Pos=(153.115555, 4.853262, -655.812439)
age=+0.227408 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.971149 | Pos=(152.819595, 4.771037, -655.639709)
age=+0.219287 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.387815 | Pos=(152.520187, 4.685340, -655.472595)
age=+0.211281 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.804482 | Pos=(152.217422, 4.596170, -655.310974)
age=+0.202575 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.221148 | Pos=(151.912003, 4.503529, -655.153992)
age=+0.194468 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.637814 | Pos=(151.603989, 4.407415, -655.001648)
age=+0.186585 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.054480 | Pos=(151.293167, 4.307829, -654.854553)
age=+0.177877 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.168496 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.161028 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.152834 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.137737 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.133845 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.123413 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.116944 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.110466 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.102929 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.094159 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.085828 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.077001 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.065368 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.049024 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.043398 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.039018 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.032061 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.015200 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.000405 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
-----------------------------------------------
==================================================


========== HUMANOID STATE CHANGED ==========
Time     = 8479.392691
From     = Jumping
To       = Freefall
Position = (144.325104, 5.990611, -654.682129)
Velocity = (-45.478039, 71.308777, -18.537380)
============================================

==================================================
VERTICAL EVENT #6
==================================================
Time       = 8479.395560
Humanoid   = Freefall
Position   = (143.756607, 6.876698, -654.913757)
Prev Vy    = 71.306938
Current Vy = 70.683792
Delta Vy   = -0.623146
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4093.236572, 0.000000, -1668.307007)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4093.236572, 0.000000, -1668.307007)
LookCFrame = pos=(147.345917, 12.324501, -655.734436) look=(-0.588918, -0.787073, -0.183553)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.291358, -0.787073, -1.138256)
Speed = 49.1
RelativeMoveDirection = (0.199487, 0.483953, -0.852053)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.349817 | Heartbeat   | HumanoidState=Freefall  | Vy=-4.554483 | Pos=(156.158737, 5.569127, -658.498352)
age=+0.341802 | Heartbeat   | HumanoidState=Freefall  | Vy=-4.971150 | Pos=(155.954727, 5.528568, -658.227600)
age=+0.334815 | Heartbeat   | HumanoidState=Freefall  | Vy=-5.387817 | Pos=(155.740799, 5.484538, -657.964172)
age=+0.327030 | Heartbeat   | HumanoidState=Freefall  | Vy=-5.804484 | Pos=(155.509384, 5.437036, -657.715393)
age=+0.318009 | Heartbeat   | HumanoidState=Freefall  | Vy=-6.221151 | Pos=(155.277969, 5.386061, -657.466614)
age=+0.309777 | Heartbeat   | HumanoidState=Freefall  | Vy=-6.637818 | Pos=(155.037857, 5.331614, -657.225769)
age=+0.301341 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.054485 | Pos=(154.786484, 5.273694, -656.996033)
age=+0.293149 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.471152 | Pos=(154.523605, 5.212303, -656.778870)
age=+0.285100 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.887819 | Pos=(154.254196, 5.147439, -656.569397)
age=+0.276319 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.304485 | Pos=(153.979202, 5.079103, -656.366760)
age=+0.267744 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.721151 | Pos=(153.693100, 5.007295, -656.179382)
age=+0.259324 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.137817 | Pos=(153.406998, 4.932014, -655.992004)
age=+0.251517 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.554483 | Pos=(153.115555, 4.853262, -655.812439)
age=+0.242376 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.971149 | Pos=(152.819595, 4.771037, -655.639709)
age=+0.234254 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.387815 | Pos=(152.520187, 4.685340, -655.472595)
age=+0.226249 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.804482 | Pos=(152.217422, 4.596170, -655.310974)
age=+0.217542 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.221148 | Pos=(151.912003, 4.503529, -655.153992)
age=+0.209435 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.637814 | Pos=(151.603989, 4.407415, -655.001648)
age=+0.201553 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.054480 | Pos=(151.293167, 4.307829, -654.854553)
age=+0.192844 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.183464 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.175995 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.167801 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.152705 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.148813 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.138380 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.131912 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.125433 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.117897 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.109126 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.100796 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.091969 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.080336 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.063991 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.058365 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.053985 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.047028 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.030168 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.015372 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.000337 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #7
==================================================
Time       = 8479.409289
Humanoid   = Freefall
Position   = (143.006668, 8.046074, -655.243347)
Prev Vy    = 70.683792
Current Vy = 69.850418
Delta Vy   = -0.833374
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4049.532471, 0.000000, -1779.997803)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4049.532471, 0.000000, -1779.997803)
LookCFrame = pos=(147.357773, 13.412911, -655.617676) look=(-0.570641, -0.790260, -0.223289)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.206250, -0.790260, -1.154535)
Speed = 49.1
RelativeMoveDirection = (0.121559, 0.121960, -0.985063)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.348512 | Heartbeat   | HumanoidState=Freefall  | Vy=-5.387817 | Pos=(155.740799, 5.484538, -657.964172)
age=+0.340728 | Heartbeat   | HumanoidState=Freefall  | Vy=-5.804484 | Pos=(155.509384, 5.437036, -657.715393)
age=+0.331707 | Heartbeat   | HumanoidState=Freefall  | Vy=-6.221151 | Pos=(155.277969, 5.386061, -657.466614)
age=+0.323475 | Heartbeat   | HumanoidState=Freefall  | Vy=-6.637818 | Pos=(155.037857, 5.331614, -657.225769)
age=+0.315039 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.054485 | Pos=(154.786484, 5.273694, -656.996033)
age=+0.306846 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.471152 | Pos=(154.523605, 5.212303, -656.778870)
age=+0.298798 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.887819 | Pos=(154.254196, 5.147439, -656.569397)
age=+0.290017 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.304485 | Pos=(153.979202, 5.079103, -656.366760)
age=+0.281442 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.721151 | Pos=(153.693100, 5.007295, -656.179382)
age=+0.273022 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.137817 | Pos=(153.406998, 4.932014, -655.992004)
age=+0.265215 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.554483 | Pos=(153.115555, 4.853262, -655.812439)
age=+0.256074 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.971149 | Pos=(152.819595, 4.771037, -655.639709)
age=+0.247952 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.387815 | Pos=(152.520187, 4.685340, -655.472595)
age=+0.239946 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.804482 | Pos=(152.217422, 4.596170, -655.310974)
age=+0.231240 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.221148 | Pos=(151.912003, 4.503529, -655.153992)
age=+0.223133 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.637814 | Pos=(151.603989, 4.407415, -655.001648)
age=+0.215251 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.054480 | Pos=(151.293167, 4.307829, -654.854553)
age=+0.206542 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.197162 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.189693 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.181499 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.166403 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.162511 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.152078 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.145610 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.139131 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.131595 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.122824 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.114494 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.105667 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.094034 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.077689 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.072063 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.067683 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.060726 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.043866 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.029070 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.014035 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.000312 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #8
==================================================
Time       = 8479.421414
Humanoid   = Freefall
Position   = (142.448700, 8.913996, -655.501343)
Prev Vy    = 69.850418
Current Vy = 69.225410
Delta Vy   = -0.625008
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4017.430176, 0.000000, -1857.655884)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4017.430176, 0.000000, -1857.655884)
LookCFrame = pos=(146.778702, 14.599586, -655.844971) look=(-0.565032, -0.791317, -0.233572)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.183007, -0.791317, -1.157724)
Speed = 49.1
RelativeMoveDirection = (0.062086, 0.011033, -0.998010)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.343864 | Heartbeat   | HumanoidState=Freefall  | Vy=-6.221151 | Pos=(155.277969, 5.386061, -657.466614)
age=+0.335632 | Heartbeat   | HumanoidState=Freefall  | Vy=-6.637818 | Pos=(155.037857, 5.331614, -657.225769)
age=+0.327196 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.054485 | Pos=(154.786484, 5.273694, -656.996033)
age=+0.319003 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.471152 | Pos=(154.523605, 5.212303, -656.778870)
age=+0.310955 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.887819 | Pos=(154.254196, 5.147439, -656.569397)
age=+0.302173 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.304485 | Pos=(153.979202, 5.079103, -656.366760)
age=+0.293599 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.721151 | Pos=(153.693100, 5.007295, -656.179382)
age=+0.285178 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.137817 | Pos=(153.406998, 4.932014, -655.992004)
age=+0.277372 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.554483 | Pos=(153.115555, 4.853262, -655.812439)
age=+0.268230 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.971149 | Pos=(152.819595, 4.771037, -655.639709)
age=+0.260109 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.387815 | Pos=(152.520187, 4.685340, -655.472595)
age=+0.252103 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.804482 | Pos=(152.217422, 4.596170, -655.310974)
age=+0.243396 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.221148 | Pos=(151.912003, 4.503529, -655.153992)
age=+0.235290 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.637814 | Pos=(151.603989, 4.407415, -655.001648)
age=+0.227407 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.054480 | Pos=(151.293167, 4.307829, -654.854553)
age=+0.218699 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.209318 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.201849 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.193655 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.178559 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.174667 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.164235 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.157766 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.151288 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.143751 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.134981 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.126650 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.117823 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.106190 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.089845 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.084220 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.079840 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.072882 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.056022 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.041227 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.026191 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.012468 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.000378 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #9
==================================================
Time       = 8479.433610
Humanoid   = Freefall
Position   = (141.903915, 9.774105, -655.787170)
Prev Vy    = 69.225410
Current Vy = 68.600403
Delta Vy   = -0.625008
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-3922.564697, 0.000000, -2058.072510)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-3922.564697, 0.000000, -2058.072510)
LookCFrame = pos=(146.247192, 15.478882, -655.916199) look=(-0.550149, -0.793426, -0.260408)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.122315, -0.793426, -1.164266)
Speed = 49.2
RelativeMoveDirection = (0.091279, -0.000332, -0.995825)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.347803 | Heartbeat   | HumanoidState=Freefall  | Vy=-6.637818 | Pos=(155.037857, 5.331614, -657.225769)
age=+0.339367 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.054485 | Pos=(154.786484, 5.273694, -656.996033)
age=+0.331175 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.471152 | Pos=(154.523605, 5.212303, -656.778870)
age=+0.323126 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.887819 | Pos=(154.254196, 5.147439, -656.569397)
age=+0.314345 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.304485 | Pos=(153.979202, 5.079103, -656.366760)
age=+0.305770 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.721151 | Pos=(153.693100, 5.007295, -656.179382)
age=+0.297350 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.137817 | Pos=(153.406998, 4.932014, -655.992004)
age=+0.289543 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.554483 | Pos=(153.115555, 4.853262, -655.812439)
age=+0.280402 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.971149 | Pos=(152.819595, 4.771037, -655.639709)
age=+0.272280 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.387815 | Pos=(152.520187, 4.685340, -655.472595)
age=+0.264275 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.804482 | Pos=(152.217422, 4.596170, -655.310974)
age=+0.255568 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.221148 | Pos=(151.912003, 4.503529, -655.153992)
age=+0.247462 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.637814 | Pos=(151.603989, 4.407415, -655.001648)
age=+0.239579 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.054480 | Pos=(151.293167, 4.307829, -654.854553)
age=+0.230870 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.221490 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.214021 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.205827 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.190731 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.186839 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.176406 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.169938 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.163460 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.155923 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.147152 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.138822 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.129995 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.118362 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.102017 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.096391 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.092011 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.085054 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.068194 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.053399 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.038363 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.024640 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.012550 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.000314 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #10
==================================================
Time       = 8479.445414
Humanoid   = Freefall
Position   = (141.361420, 10.626402, -656.077759)
Prev Vy    = 68.600403
Current Vy = 67.975395
Delta Vy   = -0.625008
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-3905.904785, 0.000000, -2092.496582)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-3905.904785, 0.000000, -2092.496582)
LookCFrame = pos=(145.697510, 16.344608, -656.173157) look=(-0.546643, -0.794476, -0.264554)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.111017, -0.794476, -1.164681)
Speed = 49.2
RelativeMoveDirection = (0.049723, -0.000031, -0.998763)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.342983 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.471152 | Pos=(154.523605, 5.212303, -656.778870)
age=+0.334935 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.887819 | Pos=(154.254196, 5.147439, -656.569397)
age=+0.326153 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.304485 | Pos=(153.979202, 5.079103, -656.366760)
age=+0.317579 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.721151 | Pos=(153.693100, 5.007295, -656.179382)
age=+0.309158 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.137817 | Pos=(153.406998, 4.932014, -655.992004)
age=+0.301352 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.554483 | Pos=(153.115555, 4.853262, -655.812439)
age=+0.292210 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.971149 | Pos=(152.819595, 4.771037, -655.639709)
age=+0.284089 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.387815 | Pos=(152.520187, 4.685340, -655.472595)
age=+0.276083 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.804482 | Pos=(152.217422, 4.596170, -655.310974)
age=+0.267377 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.221148 | Pos=(151.912003, 4.503529, -655.153992)
age=+0.259270 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.637814 | Pos=(151.603989, 4.407415, -655.001648)
age=+0.251387 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.054480 | Pos=(151.293167, 4.307829, -654.854553)
age=+0.242679 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.233298 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.225830 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.217635 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.202539 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.198647 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.188215 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.181746 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.175268 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.167731 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.158961 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.150630 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.141803 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.130170 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.113826 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.108200 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.103820 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.096862 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.080002 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.065207 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.050172 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.036448 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.024358 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.012122 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.000323 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #11
==================================================
Time       = 8479.458339
Humanoid   = Freefall
Position   = (140.822723, 11.470886, -656.376038)
Prev Vy    = 67.975395
Current Vy = 67.350388
Delta Vy   = -0.625008
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-3878.479004, 0.000000, -2147.223877)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-3878.479004, 0.000000, -2147.223877)
LookCFrame = pos=(145.159943, 17.196907, -656.411255) look=(-0.542934, -0.794476, -0.272085)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.094908, -0.794476, -1.166105)
Speed = 49.2
RelativeMoveDirection = (0.054863, -0.000003, -0.998494)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.347883 | Heartbeat   | HumanoidState=Freefall  | Vy=-7.887819 | Pos=(154.254196, 5.147439, -656.569397)
age=+0.339102 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.304485 | Pos=(153.979202, 5.079103, -656.366760)
age=+0.330527 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.721151 | Pos=(153.693100, 5.007295, -656.179382)
age=+0.322106 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.137817 | Pos=(153.406998, 4.932014, -655.992004)
age=+0.314300 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.554483 | Pos=(153.115555, 4.853262, -655.812439)
age=+0.305158 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.971149 | Pos=(152.819595, 4.771037, -655.639709)
age=+0.297037 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.387815 | Pos=(152.520187, 4.685340, -655.472595)
age=+0.289031 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.804482 | Pos=(152.217422, 4.596170, -655.310974)
age=+0.280325 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.221148 | Pos=(151.912003, 4.503529, -655.153992)
age=+0.272218 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.637814 | Pos=(151.603989, 4.407415, -655.001648)
age=+0.264335 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.054480 | Pos=(151.293167, 4.307829, -654.854553)
age=+0.255627 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.246246 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.238778 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.230584 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.215488 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.211595 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.201163 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.194694 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.188216 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.180679 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.171909 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.163578 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.154751 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.143118 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.126774 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.121148 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.116768 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.109811 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.092950 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.078155 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.063120 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.049397 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.037306 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.025070 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.013271 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.000345 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #12
==================================================
Time       = 8479.477317
Humanoid   = Freefall
Position   = (140.105133, 12.584712, -656.774963)
Prev Vy    = 67.350388
Current Vy = 66.517044
Delta Vy   = -0.833344
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-3875.037842, 0.000000, -2154.061035)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-3875.037842, 0.000000, -2154.061035)
LookCFrame = pos=(144.621811, 18.041389, -656.703003) look=(-0.542464, -0.794476, -0.273022)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.092893, -0.794476, -1.166267)
Speed = 49.2
RelativeMoveDirection = (0.042774, -0.000000, -0.999085)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.349514 | Heartbeat   | HumanoidState=Freefall  | Vy=-8.721151 | Pos=(153.693100, 5.007295, -656.179382)
age=+0.341094 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.137817 | Pos=(153.406998, 4.932014, -655.992004)
age=+0.333288 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.554483 | Pos=(153.115555, 4.853262, -655.812439)
age=+0.324146 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.971149 | Pos=(152.819595, 4.771037, -655.639709)
age=+0.316024 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.387815 | Pos=(152.520187, 4.685340, -655.472595)
age=+0.308019 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.804482 | Pos=(152.217422, 4.596170, -655.310974)
age=+0.299312 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.221148 | Pos=(151.912003, 4.503529, -655.153992)
age=+0.291206 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.637814 | Pos=(151.603989, 4.407415, -655.001648)
age=+0.283323 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.054480 | Pos=(151.293167, 4.307829, -654.854553)
age=+0.274614 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.265234 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.257765 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.249571 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.234475 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.230583 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.220150 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.213682 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.207204 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.199667 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.190897 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.182566 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.173739 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.162106 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.145761 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.140136 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.135755 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.128798 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.111938 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.097143 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.082107 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.068384 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.056294 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.044058 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.032259 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.019333 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.000386 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #13
==================================================
Time       = 8479.491019
Humanoid   = Freefall
Position   = (139.543823, 13.410967, -657.028015)
Prev Vy    = 66.517044
Current Vy = 65.892036
Delta Vy   = -0.625008
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4041.548828, 0.000000, -1821.794678)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4041.548828, 0.000000, -1821.794678)
LookCFrame = pos=(143.895828, 19.160818, -657.112427) look=(-0.541706, -0.795524, -0.271469)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.989733, -0.795524, 0.622551)
Speed = 49.2
RelativeMoveDirection = (-0.042780, -0.000000, -0.999085)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.346950 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.554483 | Pos=(153.115555, 4.853262, -655.812439)
age=+0.337809 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.971149 | Pos=(152.819595, 4.771037, -655.639709)
age=+0.329687 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.387815 | Pos=(152.520187, 4.685340, -655.472595)
age=+0.321681 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.804482 | Pos=(152.217422, 4.596170, -655.310974)
age=+0.312975 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.221148 | Pos=(151.912003, 4.503529, -655.153992)
age=+0.304868 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.637814 | Pos=(151.603989, 4.407415, -655.001648)
age=+0.296985 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.054480 | Pos=(151.293167, 4.307829, -654.854553)
age=+0.288277 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.278896 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.271428 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.263234 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.248138 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.244246 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.233813 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.227345 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.220866 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.213329 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.204559 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.196229 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.187402 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.175769 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.159424 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.153798 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.149418 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.142461 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.125601 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.110805 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.095770 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.082047 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.069956 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.057720 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.045922 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.032996 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.014049 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.000308 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #14
==================================================
Time       = 8479.503059
Humanoid   = Freefall
Position   = (138.982513, 14.229408, -657.281067)
Prev Vy    = 65.892036
Current Vy = 65.267029
Delta Vy   = -0.625008
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4041.548828, 0.000000, -1821.794678)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4041.548828, 0.000000, -1821.794678)
LookCFrame = pos=(143.334518, 19.987074, -657.365479) look=(-0.541706, -0.795524, -0.271469)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.989733, -0.795524, 0.622551)
Speed = 49.2
RelativeMoveDirection = (-0.041016, -0.000000, -0.999159)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.349916 | Heartbeat   | HumanoidState=Freefall  | Vy=-9.971149 | Pos=(152.819595, 4.771037, -655.639709)
age=+0.341795 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.387815 | Pos=(152.520187, 4.685340, -655.472595)
age=+0.333789 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.804482 | Pos=(152.217422, 4.596170, -655.310974)
age=+0.325083 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.221148 | Pos=(151.912003, 4.503529, -655.153992)
age=+0.316976 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.637814 | Pos=(151.603989, 4.407415, -655.001648)
age=+0.309093 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.054480 | Pos=(151.293167, 4.307829, -654.854553)
age=+0.300385 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.291004 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.283536 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.275341 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.260245 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.256353 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.245921 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.239452 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.232974 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.225437 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.216667 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.208336 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.199509 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.187876 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.171532 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.165906 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.161526 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.154568 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.137708 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.122913 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.107878 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.094154 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.082064 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.069828 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.058029 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.045103 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.026156 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.012415 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.000385 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #15
==================================================
Time       = 8479.515336
Humanoid   = Freefall
Position   = (138.418411, 15.040038, -657.528442)
Prev Vy    = 65.267029
Current Vy = 64.642021
Delta Vy   = -0.625008
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4061.699951, 0.000000, -1780.521118)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4061.699951, 0.000000, -1780.521118)
LookCFrame = pos=(142.753708, 20.816673, -657.665527) look=(-0.542018, -0.797613, -0.264631)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.980752, -0.797613, 0.633986)
Speed = 49.2
RelativeMoveDirection = (-0.051385, -0.000000, -0.998679)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.346007 | Heartbeat   | HumanoidState=Freefall  | Vy=-10.804482 | Pos=(152.217422, 4.596170, -655.310974)
age=+0.337301 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.221148 | Pos=(151.912003, 4.503529, -655.153992)
age=+0.329194 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.637814 | Pos=(151.603989, 4.407415, -655.001648)
age=+0.321312 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.054480 | Pos=(151.293167, 4.307829, -654.854553)
age=+0.312603 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.303223 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.295754 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.287560 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.272464 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.268572 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.258139 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.251671 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.245192 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.237656 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.228885 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.220555 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.211728 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.200095 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.183750 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.178124 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.173744 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.166787 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.149927 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.135131 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.120096 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.106373 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.094283 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.082047 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.070248 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.057322 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.038375 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.024634 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.012603 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.000338 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #16
==================================================
Time       = 8479.526748
Humanoid   = Freefall
Position   = (137.851562, 15.842855, -657.769958)
Prev Vy    = 64.642021
Current Vy = 64.017014
Delta Vy   = -0.625008
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4081.429443, 0.000000, -1739.025391)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4081.429443, 0.000000, -1739.025391)
LookCFrame = pos=(142.185425, 21.627304, -657.951965) look=(-0.544732, -0.797613, -0.258997)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.974127, -0.797613, 0.644120)
Speed = 49.2
RelativeMoveDirection = (-0.051370, -0.000000, -0.998680)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.348704 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.221148 | Pos=(151.912003, 4.503529, -655.153992)
age=+0.340598 | Heartbeat   | HumanoidState=Freefall  | Vy=-11.637814 | Pos=(151.603989, 4.407415, -655.001648)
age=+0.332715 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.054480 | Pos=(151.293167, 4.307829, -654.854553)
age=+0.324006 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.314626 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.307157 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.298963 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.283867 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.279975 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.269542 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.263074 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.256596 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.249059 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.240288 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.231958 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.223131 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.211498 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.195153 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.189527 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.185147 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.178190 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.161330 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.146535 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.131499 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.117776 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.105686 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.093450 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.081651 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.068725 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.049778 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.036037 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.024006 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.011741 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.000300 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #17
==================================================
Time       = 8479.538106
Humanoid   = Freefall
Position   = (137.283798, 16.637859, -658.009644)
Prev Vy    = 64.017014
Current Vy = 63.392017
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4087.959717, 0.000000, -1725.167358)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4087.959717, 0.000000, -1725.167358)
LookCFrame = pos=(141.609146, 22.435677, -658.210266) look=(-0.544377, -0.798654, -0.256526)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.970648, -0.798654, 0.648070)
Speed = 49.3
RelativeMoveDirection = (-0.044461, -0.000000, -0.999011)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.344071 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.054480 | Pos=(151.293167, 4.307829, -654.854553)
age=+0.335362 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.325982 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.318513 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.310319 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.295223 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.291331 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.280898 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.274430 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.267951 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.260415 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.251644 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.243314 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.234487 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.222854 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.206509 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.200883 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.196503 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.189546 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.172686 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.157890 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.142855 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.129132 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.117042 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.104806 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.093007 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.080081 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.061134 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.047393 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.035362 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.023097 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.011656 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.000302 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #18
==================================================
Time       = 8479.549431
Humanoid   = Freefall
Position   = (136.711639, 17.425053, -658.239624)
Prev Vy    = 63.392017
Current Vy = 62.767021
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4119.420410, 0.000000, -1655.297852)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4119.420410, 0.000000, -1655.297852)
LookCFrame = pos=(141.033203, 23.230680, -658.514771) look=(-0.548728, -0.798654, -0.247082)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.959305, -0.798654, 0.664744)
Speed = 49.3
RelativeMoveDirection = (-0.058246, -0.000000, -0.998302)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.346689 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.471146 | Pos=(150.978104, 4.204771, -654.716003)
age=+0.337309 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.329840 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.321646 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.306550 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.302658 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.292225 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.285757 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.279278 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.271742 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.262971 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.254641 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.245814 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.234181 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.217836 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.212210 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.207830 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.200873 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.184013 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.169217 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.154182 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.140459 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.128369 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.116133 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.104334 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.091408 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.072461 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.058720 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.046689 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.034424 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.022983 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.011628 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.000306 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #19
==================================================
Time       = 8479.561515
Humanoid   = Freefall
Position   = (136.327148, 17.945507, -658.385742)
Prev Vy    = 62.767021
Current Vy = 62.350357
Delta Vy   = -0.416664
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4152.580078, 0.000000, -1577.752075)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4152.580078, 0.000000, -1577.752075)
LookCFrame = pos=(140.442673, 24.023415, -658.819397) look=(-0.552055, -0.799693, -0.236065)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.945229, -0.799693, 0.683399)
Speed = 49.3
RelativeMoveDirection = (-0.059941, -0.000000, -0.998202)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.349456 | Heartbeat   | HumanoidState=Freefall  | Vy=-12.887812 | Pos=(150.659500, 4.098241, -654.585022)
age=+0.341988 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.304478 | Pos=(150.338455, 3.988238, -654.459412)
age=+0.333794 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.318697 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.314805 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.304373 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.297904 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.291426 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.283889 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.275119 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.266788 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.257961 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.246328 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.229984 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.224358 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.219978 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.213021 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.196160 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.181365 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.166330 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.152607 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.140516 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.128280 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.116481 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.103555 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.084608 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.070867 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.058837 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.046571 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.035131 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.023776 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.012454 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.000395 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #20
==================================================
Time       = 8479.573269
Humanoid   = Freefall
Position   = (135.743408, 18.719677, -658.586975)
Prev Vy    = 62.350357
Current Vy = 61.725361
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4202.906250, 0.000000, -1449.137207)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4202.906250, 0.000000, -1449.137207)
LookCFrame = pos=(140.038345, 24.543869, -659.081238) look=(-0.559129, -0.799693, -0.218784)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.923520, -0.799693, 0.712462)
Speed = 49.3
RelativeMoveDirection = (-0.071978, -0.000000, -0.997406)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.345483 | Heartbeat   | HumanoidState=Freefall  | Vy=-13.721144 | Pos=(150.015060, 3.874763, -654.339294)
age=+0.330387 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.326495 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.316062 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.309594 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.303115 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.295578 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.286808 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.278478 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.269651 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.258018 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.241673 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.236047 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.231667 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.224710 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.207850 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.193054 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.178019 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.164296 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.152205 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.139969 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.128171 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.115244 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.096298 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.082557 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.070526 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.058260 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.046820 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.035465 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.024143 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.012084 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.000316 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #21
==================================================
Time       = 8479.585113
Humanoid   = Freefall
Position   = (135.154221, 19.486036, -658.773193)
Prev Vy    = 61.725361
Current Vy = 61.100365
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4242.081543, 0.000000, -1340.828247)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4242.081543, 0.000000, -1340.828247)
LookCFrame = pos=(139.427048, 25.323566, -659.381409) look=(-0.563310, -0.800729, -0.203750)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.903446, -0.800729, 0.736626)
Speed = 49.4
RelativeMoveDirection = (-0.066769, -0.000000, -0.997768)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.342274 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.346143 | Pos=(149.526627, 3.698041, -654.167358)
age=+0.338382 | Heartbeat   | HumanoidState=Freefall  | Vy=-14.554476 | Pos=(149.361938, 3.637397, -654.115051)
age=+0.327949 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.321481 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.315003 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.307466 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.298696 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.290365 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.281538 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.269905 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.253560 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.247934 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.243554 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.236597 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.219737 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.204942 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.189906 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.176183 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.164093 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.151857 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.140058 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.127132 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.108185 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.094444 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.082413 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.070148 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.058707 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.047353 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.036030 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.023971 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.012204 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.000403 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #22
==================================================
Time       = 8479.597708
Humanoid   = Freefall
Position   = (134.559998, 20.244583, -658.944214)
Prev Vy    = 61.100365
Current Vy = 60.475368
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4278.463379, 0.000000, -1231.460938)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4278.463379, 0.000000, -1231.460938)
LookCFrame = pos=(138.816040, 26.089924, -659.662781) look=(-0.568401, -0.800729, -0.189083)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.884053, -0.800729, 0.759792)
Speed = 49.4
RelativeMoveDirection = (-0.066742, -0.000000, -0.997770)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.340549 | Heartbeat   | HumanoidState=Landed    | Vy=-15.179475 | Pos=(148.867874, 3.450258, -653.958130)
age=+0.334081 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.327602 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.320065 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.311295 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.302964 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.294138 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.282505 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.266160 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.260534 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.256154 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.249197 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.232337 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.217541 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.202506 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.188783 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.176692 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.164456 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.152657 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.139731 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.120785 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.107044 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.095013 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.082747 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.071307 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.059952 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.048630 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.036571 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.024803 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.013003 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.000356 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #23
==================================================
Time       = 8479.610778
Humanoid   = Freefall
Position   = (133.958450, 20.995316, -659.089600)
Prev Vy    = 60.475368
Current Vy = 59.850372
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4331.218262, 0.000000, -1046.570801)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4331.218262, 0.000000, -1046.570801)
LookCFrame = pos=(138.171494, 26.853983, -659.993591) look=(-0.574705, -0.801763, -0.163982)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.849086, -0.801763, 0.797639)
Speed = 49.5
RelativeMoveDirection = (-0.083937, -0.000000, -0.996471)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.347102 | Heartbeat   | HumanoidState=Landed    | Vy=-15.387808 | Pos=(148.701294, 3.386142, -653.911499)
age=+0.340624 | Heartbeat   | HumanoidState=Landed    | Vy=-15.804474 | Pos=(148.365387, 3.255306, -653.827393)
age=+0.333087 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.324317 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.315986 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.307159 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.295526 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.279182 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.273556 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.269176 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.262218 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.245358 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.230563 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.215528 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.201804 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.189714 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.177478 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.165679 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.152753 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.133806 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.120065 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.108035 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.095769 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.084329 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.072974 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.061652 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.049592 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.037825 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.026025 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.013377 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.000330 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #24
==================================================
Time       = 8479.622004
Humanoid   = Freefall
Position   = (133.354156, 21.738237, -659.224548)
Prev Vy    = 59.850372
Current Vy = 59.225376
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4351.050293, 0.000000, -972.219299)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4351.050293, 0.000000, -972.219299)
LookCFrame = pos=(137.551285, 27.604715, -660.201172) look=(-0.577453, -0.801763, -0.154027)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.835178, -0.801763, 0.812191)
Speed = 49.5
RelativeMoveDirection = (-0.058055, -0.000000, -0.998314)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.344350 | Heartbeat   | HumanoidState=Landed    | Vy=-16.221142 | Pos=(148.026794, 3.120998, -653.753052)
age=+0.335580 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.327249 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.318423 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.306790 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.290445 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.284819 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.280439 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.273482 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.256622 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.241826 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.226791 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.213068 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.200977 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.188741 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.176942 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.164016 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.145070 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.131329 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.119298 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.107032 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.095592 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.084237 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.072915 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.060856 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.049088 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.037288 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.024641 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.011594 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.000357 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #25
==================================================
Time       = 8479.633644
Humanoid   = Freefall
Position   = (132.743362, 22.473347, -659.329285)
Prev Vy    = 59.225376
Current Vy = 58.600380
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4397.731934, 0.000000, -753.802490)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4397.731934, 0.000000, -753.802490)
LookCFrame = pos=(136.878159, 28.353134, -660.516541) look=(-0.583087, -0.802795, -0.124621)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.792093, -0.802795, 0.853293)
Speed = 49.5
RelativeMoveDirection = (-0.090770, -0.000000, -0.995872)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.347201 | Heartbeat   | HumanoidState=Landed    | Vy=-16.637810 | Pos=(147.685608, 2.983218, -653.689819)
age=+0.338870 | Heartbeat   | HumanoidState=Landed    | Vy=-17.054478 | Pos=(147.342072, 2.841965, -653.638306)
age=+0.330043 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.318410 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.302065 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.296439 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.292059 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.285102 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.268242 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.253447 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.238411 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.224688 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.212598 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.200362 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.188563 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.175637 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.156690 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.142949 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.130918 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.118653 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.107212 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.095858 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.084535 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.072476 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.060709 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.048908 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.036261 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.023214 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.011977 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.000351 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #26
==================================================
Time       = 8479.645007
Humanoid   = Freefall
Position   = (132.129639, 23.200642, -659.418274)
Prev Vy    = 58.600380
Current Vy = 57.975384
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4418.954590, 0.000000, -640.172241)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4418.954590, 0.000000, -640.172241)
LookCFrame = pos=(136.224014, 29.093723, -660.713806) look=(-0.584756, -0.803824, -0.109214)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.768350, -0.803824, 0.873789)
Speed = 49.6
RelativeMoveDirection = (-0.066614, -0.000000, -0.997779)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.341413 | Heartbeat   | HumanoidState=Running   | Vy=-11.993769 | Pos=(146.980774, 2.720062, -653.625610)
age=+0.329780 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.313435 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.307809 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.303429 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.296472 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.279612 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.264816 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.249781 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.236058 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.223967 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.211732 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.199933 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.187007 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.168060 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.154319 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.142288 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.130023 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.118582 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.107227 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.095905 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.083846 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.072078 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.060278 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.047631 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.034584 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.023347 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.011721 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.000343 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #27
==================================================
Time       = 8479.656822
Humanoid   = Freefall
Position   = (131.718689, 23.681166, -659.466248)
Prev Vy    = 57.975384
Current Vy = 57.558720
Delta Vy   = -0.416664
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4438.247070, 0.000000, -518.297058)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4438.247070, 0.000000, -518.297058)
LookCFrame = pos=(135.561935, 29.826483, -660.899841) look=(-0.586179, -0.804850, -0.092791)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.742530, -0.804850, 0.894911)
Speed = 49.6
RelativeMoveDirection = (-0.068315, -0.000000, -0.997664)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.341578 | Heartbeat   | HumanoidState=Jumping   | Vy=+17.112175 | Pos=(146.603912, 2.863532, -653.653931)
age=+0.325234 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.319608 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.315228 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.308270 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.291410 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.276615 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.261580 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.247856 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.235766 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.223530 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.211731 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.198805 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.179858 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.166117 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.154087 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.141821 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.130381 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.119026 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.107704 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.095645 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.083877 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.072077 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.059429 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.046382 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.035146 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.023519 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.012141 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.000333 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #28
==================================================
Time       = 8479.669476
Humanoid   = Freefall
Position   = (131.100159, 24.395443, -659.522278)
Prev Vy    = 57.558720
Current Vy = 56.933723
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4453.377930, 0.000000, -403.525269)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4453.377930, 0.000000, -403.525269)
LookCFrame = pos=(135.111435, 30.307007, -661.036316) look=(-0.588387, -0.804850, -0.077569)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.719089, -0.804850, 0.913853)
Speed = 49.6
RelativeMoveDirection = (-0.066566, -0.000000, -0.997782)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.337889 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.332263 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.327883 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.320925 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.304065 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.289270 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.274235 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.260511 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.248421 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.236185 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.224386 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.211460 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.192513 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.178772 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.166742 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.154476 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.143036 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.131681 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.120359 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.108299 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.096532 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.084732 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.072084 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.059037 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.047801 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.036174 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.024796 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.012988 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.000309 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #29
==================================================
Time       = 8479.681498
Humanoid   = Freefall
Position   = (130.480026, 25.101906, -659.563477)
Prev Vy    = 56.933723
Current Vy = 56.308727
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4464.912598, 0.000000, -296.019348)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4464.912598, 0.000000, -296.019348)
LookCFrame = pos=(134.445129, 31.026733, -661.174866) look=(-0.588707, -0.805875, -0.063166)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.695390, -0.805875, 0.931128)
Speed = 49.7
RelativeMoveDirection = (-0.064810, -0.000000, -0.997898)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.349891 | Heartbeat   | HumanoidState=Freefall  | Vy=+16.278618 | Pos=(145.901138, 3.139949, -653.796448)
age=+0.344265 | Heartbeat   | HumanoidState=Freefall  | Vy=+23.024704 | Pos=(145.653854, 3.314197, -653.921936)
age=+0.339885 | Heartbeat   | HumanoidState=Climbing  | Vy=+11.952947 | Pos=(145.696198, 3.363925, -653.992249)
age=+0.332927 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.316067 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.301272 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.286237 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.272513 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.260423 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.248187 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.236388 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.223462 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.204515 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.190774 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.178744 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.166478 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.155038 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.143683 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.132361 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.120301 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.108534 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.096734 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.084086 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.071039 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.059803 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.048176 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.036798 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.024990 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.012311 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.000312 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #30
==================================================
Time       = 8479.693580
Humanoid   = Freefall
Position   = (129.858932, 25.800556, -659.593872)
Prev Vy    = 56.308727
Current Vy = 55.683731
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4471.828125, 0.000000, -219.052368)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4471.828125, 0.000000, -219.052368)
LookCFrame = pos=(133.795944, 31.733196, -661.273560) look=(-0.589711, -0.805875, -0.052984)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.679199, -0.805875, 0.943004)
Speed = 49.7
RelativeMoveDirection = (-0.057892, -0.000000, -0.998323)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.345037 | Heartbeat   | HumanoidState=Jumping   | Vy=+42.383430 | Pos=(145.733032, 3.540446, -654.063965)
age=+0.328177 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.313381 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.298346 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.284623 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.272532 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.260296 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.248497 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.235571 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.216625 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.202884 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.190853 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.178587 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.167147 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.155792 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.144470 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.132411 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.120643 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.108843 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.096196 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.083149 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.071912 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.060286 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.048908 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.037100 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.024420 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.012422 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.000328 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #31
==================================================
Time       = 8479.706297
Humanoid   = Freefall
Position   = (129.237564, 26.491396, -659.621155)
Prev Vy    = 55.683731
Current Vy = 55.058735
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4473.783691, 0.000000, -195.943985)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4473.783691, 0.000000, -195.943985)
LookCFrame = pos=(133.165955, 32.431847, -661.321167) look=(-0.589978, -0.805875, -0.049927)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.674301, -0.805875, 0.946511)
Speed = 49.7
RelativeMoveDirection = (-0.045808, -0.000000, -0.998950)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.340931 | Heartbeat   | HumanoidState=Jumping   | Vy=+69.650375 | Pos=(145.083099, 4.807478, -654.373047)
age=+0.326136 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.311101 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.297377 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.285287 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.273051 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.261252 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.248326 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.229379 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.215638 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.203608 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.191342 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.179901 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.168547 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.157225 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.145165 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.133398 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.121598 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.108950 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.095903 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.084667 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.073040 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.061662 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.049854 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.037175 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.025176 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.013083 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.000380 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #32
==================================================
Time       = 8479.718213
Humanoid   = Freefall
Position   = (128.615326, 27.174421, -659.634521)
Prev Vy    = 55.058735
Current Vy = 54.433739
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4480.009277, 0.000000, -95.594437)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4480.009277, 0.000000, -95.594437)
LookCFrame = pos=(132.504944, 33.122688, -661.422302) look=(-0.590950, -0.805875, -0.036663)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.652872, -0.805875, 0.961418)
Speed = 49.7
RelativeMoveDirection = (-0.063040, -0.000000, -0.998011)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.338017 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.322982 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.309259 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.297169 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.284933 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.273134 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.260208 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.241261 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.227520 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.215489 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.203224 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.191783 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.180428 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.169106 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.157047 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.145280 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.133479 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.120832 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.107785 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.096548 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.084922 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.073544 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.061736 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.049057 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.037058 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.024964 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.012262 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.000328 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #33
==================================================
Time       = 8479.730041
Humanoid   = Freefall
Position   = (127.992989, 27.849634, -659.645691)
Prev Vy    = 54.433739
Current Vy = 53.808743
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4480.914062, 0.000000, -80.147278)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4480.914062, 0.000000, -80.147278)
LookCFrame = pos=(131.876465, 33.805710, -661.446960) look=(-0.591073, -0.805875, -0.034621)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.649546, -0.805875, 0.963668)
Speed = 49.7
RelativeMoveDirection = (-0.044049, -0.000000, -0.999029)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.349846 | Heartbeat   | HumanoidState=Jumping   | Vy=+71.306938 | Pos=(144.325104, 5.990611, -654.682129)
age=+0.334810 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.321087 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.308997 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.296761 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.284962 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.272036 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.253089 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.239348 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.227318 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.215052 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.203611 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.192257 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.180935 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.168875 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.157108 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.145308 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.132660 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.119613 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.108377 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.096750 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.085372 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.073564 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.060885 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.048886 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.036793 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.024090 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.012156 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.000342 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #34
==================================================
Time       = 8479.742227
Humanoid   = Freefall
Position   = (127.370476, 28.517036, -659.653564)
Prev Vy    = 53.808743
Current Vy = 53.183746
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4482.151367, 0.000000, -56.966221)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4482.151367, 0.000000, -56.966221)
LookCFrame = pos=(131.244690, 34.480927, -661.474976) look=(-0.591245, -0.805875, -0.031556)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.644542, -0.805875, 0.967022)
Speed = 49.8
RelativeMoveDirection = (-0.045773, -0.000000, -0.998952)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.346965 | Heartbeat   | HumanoidState=Freefall  | Vy=+70.683792 | Pos=(143.756607, 6.876698, -654.913757)
age=+0.333242 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.321152 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.308916 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.297117 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.284191 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.265244 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.251503 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.239473 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.227207 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.215766 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.204412 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.193090 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.181030 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.169263 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.157463 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.144815 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.131768 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.120532 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.108905 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.097527 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.085719 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.073040 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.061041 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.048948 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.036245 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.024311 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.012497 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.000298 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #35
==================================================
Time       = 8479.753795
Humanoid   = Freefall
Position   = (126.747963, 29.176624, -659.661438)
Prev Vy    = 53.183746
Current Vy = 52.558750
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4482.151367, 0.000000, -56.966221)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4482.151367, 0.000000, -56.966221)
LookCFrame = pos=(130.622177, 35.148327, -661.482849) look=(-0.591245, -0.805875, -0.031556)
MoveDirection = (-1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.644542, -0.805875, 0.967022)
Speed = 49.8
RelativeMoveDirection = (-0.040595, -0.000000, -0.999176)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.344823 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.850418 | Pos=(143.006668, 8.046074, -655.243347)
age=+0.332733 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.320497 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.308698 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.295772 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.276825 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.263084 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.251054 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.238788 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.227347 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.215993 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.204671 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.192611 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.180844 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.169044 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.156396 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.143349 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.132113 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.120486 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.109108 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.097300 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.084621 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.072622 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.060529 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.047826 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.035892 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.024078 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.011879 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.000298 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #36
==================================================
Time       = 8479.766902
Humanoid   = Freefall
Position   = (126.125450, 29.828400, -659.669312)
Prev Vy    = 52.558750
Current Vy = 51.933754
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4482.151367, 0.000000, -56.966221)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4482.151367, 0.000000, -56.966221)
LookCFrame = pos=(129.999664, 35.807915, -661.490723) look=(-0.591245, -0.805875, -0.031556)
MoveDirection = (0.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.591245, -0.805875, -0.031556)
Speed = 49.8
RelativeMoveDirection = (-0.040597, -0.000000, -0.999176)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.345880 | Heartbeat   | HumanoidState=Freefall  | Vy=+69.225410 | Pos=(142.448700, 8.913996, -655.501343)
age=+0.333644 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.321845 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.308919 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.289972 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.276231 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.264201 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.251935 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.240495 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.229140 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.217818 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.205759 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.193991 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.182191 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.169544 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.156496 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.145260 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.133634 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.122255 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.110447 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.097768 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.085769 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.073676 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.060973 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.049039 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.037225 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.025026 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.013446 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.000370 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #37
==================================================
Time       = 8479.780270
Humanoid   = Freefall
Position   = (125.502937, 30.472364, -659.677185)
Prev Vy    = 51.933754
Current Vy = 51.308758
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4482.151367, 0.000000, -56.966221)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4482.151367, 0.000000, -56.966221)
LookCFrame = pos=(129.377151, 36.459690, -661.498596) look=(-0.591245, -0.805875, -0.031556)
MoveDirection = (0.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.591245, -0.805875, -0.031556)
Speed = 49.8
RelativeMoveDirection = (-0.040598, -0.000000, -0.999176)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.347001 | Heartbeat   | HumanoidState=Freefall  | Vy=+68.600403 | Pos=(141.903915, 9.774105, -655.787170)
age=+0.335202 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.975395 | Pos=(141.361420, 10.626402, -656.077759)
age=+0.322276 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.303329 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.289588 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.277558 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.265292 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.253852 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.242497 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.231175 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.219116 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.207348 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.195548 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.182900 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.169853 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.158617 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.146990 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.135612 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.123804 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.111125 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.099126 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.087033 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.074330 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.062396 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.050582 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.038383 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.026802 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.013727 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.000355 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #38
==================================================
Time       = 8479.795061
Humanoid   = Freefall
Position   = (124.884041, 31.108515, -659.742004)
Prev Vy    = 51.308758
Current Vy = 50.683762
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4456.029297, 0.000000, -466.556671)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4456.029297, 0.000000, -466.556671)
LookCFrame = pos=(128.764572, 37.109089, -661.473206) look=(-0.589495, -0.806896, -0.037596)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.525849, -0.806896, -1.035568)
Speed = 49.7
RelativeMoveDirection = (0.050982, -0.000000, -0.998700)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.337077 | Heartbeat   | HumanoidState=Freefall  | Vy=+67.350388 | Pos=(140.822723, 11.470886, -656.376038)
age=+0.318130 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.304389 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.292359 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.280093 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.268652 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.257298 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.245976 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.233916 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.222149 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.210349 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.197701 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.184654 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.173418 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.161791 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.150413 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.138605 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.125926 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.113927 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.101834 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.089131 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.077197 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.065383 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.053184 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.041603 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.028528 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.015156 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.000365 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #39
==================================================
Time       = 8479.808553
Humanoid   = Freefall
Position   = (124.059242, 31.944563, -659.834045)
Prev Vy    = 50.683762
Current Vy = 49.850433
Delta Vy   = -0.833328
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4453.846191, 0.000000, -497.424316)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4453.846191, 0.000000, -497.424316)
LookCFrame = pos=(128.158005, 37.745235, -661.515503) look=(-0.589221, -0.806896, -0.041669)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.518679, -0.806896, -1.039178)
Speed = 49.7
RelativeMoveDirection = (0.047479, -0.000000, -0.998872)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.331578 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.317837 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.305807 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.293541 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.282100 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.270746 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.259424 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.247364 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.235597 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.223797 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.211149 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.198102 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.186866 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.175239 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.163861 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.152053 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.139374 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.127375 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.115282 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.102579 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.090645 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.078831 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.066632 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.055051 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.041976 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.028604 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.013813 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.000310 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #40
==================================================
Time       = 8479.821122
Humanoid   = Freefall
Position   = (123.440895, 32.562485, -659.906372)
Prev Vy    = 49.850433
Current Vy = 49.225437
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4452.088379, 0.000000, -520.571716)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4452.088379, 0.000000, -520.571716)
LookCFrame = pos=(127.342361, 38.581287, -661.590515) look=(-0.588998, -0.806896, -0.044723)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.513285, -0.806896, -1.041852)
Speed = 49.8
RelativeMoveDirection = (0.045773, -0.000000, -0.998952)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.344167 | Heartbeat   | HumanoidState=Freefall  | Vy=+66.517044 | Pos=(140.105133, 12.584712, -656.774963)
age=+0.330426 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.318395 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.306130 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.294689 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.283334 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.272012 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.259953 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.248185 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.236385 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.223738 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.210691 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.199454 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.187828 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.176450 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.164642 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.151963 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.139964 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.127870 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.115167 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.103234 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.091419 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.079220 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.067640 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.054564 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.041192 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.026402 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.012899 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.000341 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #41
==================================================
Time       = 8479.834477
Humanoid   = Freefall
Position   = (122.823669, 33.172596, -659.990417)
Prev Vy    = 49.225437
Current Vy = 48.600441
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4444.028809, 0.000000, -605.342590)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4444.028809, 0.000000, -605.342590)
LookCFrame = pos=(126.756798, 39.199207, -661.600159) look=(-0.588041, -0.806896, -0.055909)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.493392, -0.806896, -1.051419)
Speed = 49.8
RelativeMoveDirection = (0.059560, -0.000000, -0.998225)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.343774 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.892036 | Pos=(139.543823, 13.410967, -657.028015)
age=+0.331743 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.319478 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.308037 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.296683 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.285360 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.273301 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.261534 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.249733 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.237086 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.224039 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.212802 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.201176 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.189798 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.177990 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.165311 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.153312 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.141218 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.128516 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.116582 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.104768 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.092569 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.080988 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.067913 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.054541 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.039750 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.026247 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.013689 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.000326 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #42
==================================================
Time       = 8479.847788
Humanoid   = Freefall
Position   = (122.207245, 33.774895, -660.081970)
Prev Vy    = 48.600441
Current Vy = 47.975445
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4438.245117, 0.000000, -659.247803)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4438.245117, 0.000000, -659.247803)
LookCFrame = pos=(126.159821, 39.809319, -661.643921) look=(-0.587322, -0.806896, -0.063017)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.480639, -0.806896, -1.057310)
Speed = 49.8
RelativeMoveDirection = (0.052637, -0.000000, -0.998614)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.345078 | Heartbeat   | HumanoidState=Freefall  | Vy=+65.267029 | Pos=(138.982513, 14.229408, -657.281067)
age=+0.332812 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.321371 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.310017 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.298695 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.286635 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.274868 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.263068 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.250420 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.237373 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.226137 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.214510 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.203132 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.191324 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.178645 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.166646 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.154553 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.141850 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.129916 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.118102 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.105903 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.094322 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.081247 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.067875 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.053084 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.039581 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.027023 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.013661 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.000337 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #43
==================================================
Time       = 8479.860957
Humanoid   = Freefall
Position   = (121.594849, 34.369377, -660.200073)
Prev Vy    = 47.975445
Current Vy = 47.350449
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4409.272461, 0.000000, -850.841492)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4409.272461, 0.000000, -850.841492)
LookCFrame = pos=(125.611694, 40.411617, -661.589905) look=(-0.584053, -0.806896, -0.088321)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.434532, -0.806896, -1.077079)
Speed = 49.8
RelativeMoveDirection = (0.083634, -0.000000, -0.996496)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.345967 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.642021 | Pos=(138.418411, 15.040038, -657.528442)
age=+0.334526 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.323172 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.311849 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.299790 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.288023 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.276222 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.263575 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.250528 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.239291 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.227665 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.216287 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.204479 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.191800 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.179801 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.167707 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.155005 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.143071 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.131256 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.119057 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.107477 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.094402 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.081030 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.066239 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.052736 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.040178 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.026815 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.013492 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.000329 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #44
==================================================
Time       = 8479.873812
Humanoid   = Freefall
Position   = (120.983482, 34.956051, -660.324585)
Prev Vy    = 47.350449
Current Vy = 46.725452
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4401.839355, 0.000000, -896.770081)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4401.839355, 0.000000, -896.770081)
LookCFrame = pos=(125.014740, 41.006100, -661.672607) look=(-0.583106, -0.806896, -0.094371)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.423343, -0.806896, -1.081526)
Speed = 49.9
RelativeMoveDirection = (0.050853, -0.000000, -0.998706)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.347428 | Heartbeat   | HumanoidState=Freefall  | Vy=+64.017014 | Pos=(137.851562, 15.842855, -657.769958)
age=+0.336073 | Heartbeat   | HumanoidState=Freefall  | Vy=+63.392017 | Pos=(137.283798, 16.637859, -658.009644)
age=+0.324751 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.312692 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.300924 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.289124 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.276477 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.263430 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.252193 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.240567 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.229189 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.217381 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.204701 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.192703 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.180609 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.167906 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.155973 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.144158 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.131959 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.120379 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.107303 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.093931 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.079141 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.065637 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.053080 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.039717 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.026393 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.013230 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.000390 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #45
==================================================
Time       = 8479.887980
Humanoid   = Freefall
Position   = (120.177025, 35.726128, -660.531372)
Prev Vy    = 46.725452
Current Vy = 45.892124
Delta Vy   = -0.833328
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4354.802734, 0.000000, -1116.849243)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4354.802734, 0.000000, -1116.849243)
LookCFrame = pos=(124.472839, 41.592773, -661.624023) look=(-0.577647, -0.806896, -0.123459)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.368640, -0.806896, -1.101373)
Speed = 49.9
RelativeMoveDirection = (0.090473, -0.000000, -0.995899)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.338872 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.767021 | Pos=(136.711639, 17.425053, -658.239624)
age=+0.326813 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.315045 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.303245 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.290598 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.277551 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.266314 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.254688 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.243309 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.231502 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.218822 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.206823 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.194730 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.182027 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.170093 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.158279 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.146080 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.134500 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.121424 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.108052 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.093262 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.079758 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.067200 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.053838 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.040514 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.027351 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.014511 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.000353 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #46
==================================================
Time       = 8479.900762
Humanoid   = Freefall
Position   = (119.578636, 36.294571, -660.711548)
Prev Vy    = 45.892124
Current Vy = 45.267128
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4308.324707, 0.000000, -1297.345093)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4308.324707, 0.000000, -1297.345093)
LookCFrame = pos=(123.708656, 42.368271, -661.687195) look=(-0.570681, -0.807916, -0.146952)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.321313, -0.807916, -1.115361)
Speed = 49.9
RelativeMoveDirection = (0.081815, -0.000000, -0.996647)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.339574 | Heartbeat   | HumanoidState=Freefall  | Vy=+62.350357 | Pos=(136.327148, 17.945507, -658.385742)
age=+0.327807 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.316007 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.303359 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.290312 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.279076 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.267449 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.256071 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.244263 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.231584 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.219585 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.207492 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.194789 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.182855 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.171041 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.158842 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.147261 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.134186 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.120814 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.106023 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.092520 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.079962 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.066599 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.053276 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.040113 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.027272 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.013114 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.000293 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #47
==================================================
Time       = 8479.913283
Humanoid   = Freefall
Position   = (118.983749, 36.855202, -660.904175)
Prev Vy    = 45.267128
Current Vy = 44.642132
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4283.204102, 0.000000, -1387.146606)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4283.204102, 0.000000, -1387.146606)
LookCFrame = pos=(123.133469, 42.936714, -661.793945) look=(-0.567512, -0.807916, -0.158753)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.298119, -0.807916, -1.121783)
Speed = 50
RelativeMoveDirection = (0.061113, -0.000000, -0.998131)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.340337 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.725361 | Pos=(135.743408, 18.719677, -658.586975)
age=+0.328537 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.315890 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.302843 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.291606 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.279980 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.268602 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.256794 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.244115 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.232116 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.220022 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.207319 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.195386 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.183571 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.171372 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.159792 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.146716 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.133344 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.118554 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.105051 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.092493 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.079130 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.065807 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.052644 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.039803 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.025645 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.012823 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.000296 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #48
==================================================
Time       = 8479.926180
Humanoid   = Freefall
Position   = (118.402481, 37.408020, -661.135620)
Prev Vy    = 44.642132
Current Vy = 44.017136
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4185.081543, 0.000000, -1665.934082)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4185.081543, 0.000000, -1665.934082)
LookCFrame = pos=(122.601936, 43.497345, -661.750977) look=(-0.555873, -0.807916, -0.195646)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.223874, -0.807916, -1.138926)
Speed = 50
RelativeMoveDirection = (0.105865, -0.000000, -0.994381)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.341405 | Heartbeat   | HumanoidState=Freefall  | Vy=+61.100365 | Pos=(135.154221, 19.486036, -658.773193)
age=+0.328758 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.315711 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.304474 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.292848 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.281470 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.269662 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.256983 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.244984 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.232890 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.220187 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.208254 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.196439 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.184240 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.172660 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.159584 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.146212 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.131422 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.117919 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.105361 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.091998 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.078675 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.065512 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.052671 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.038513 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.025691 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.013164 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.000268 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #49
==================================================
Time       = 8479.938953
Humanoid   = Freefall
Position   = (117.826180, 37.953026, -661.380066)
Prev Vy    = 44.017136
Current Vy = 43.392139
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4149.370117, 0.000000, -1760.555298)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4149.370117, 0.000000, -1760.555298)
LookCFrame = pos=(122.038780, 44.050163, -661.900940) look=(-0.551338, -0.807916, -0.208082)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.198237, -0.807916, -1.143667)
Speed = 50
RelativeMoveDirection = (0.062781, -0.000000, -0.998027)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.341595 | Heartbeat   | HumanoidState=Freefall  | Vy=+60.475368 | Pos=(134.559998, 20.244583, -658.944214)
age=+0.328548 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.317311 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.305685 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.294307 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.282499 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.269819 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.257821 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.245727 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.233024 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.221091 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.209276 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.197077 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.185497 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.172421 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.159049 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.144259 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.130755 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.118198 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.104835 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.091511 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.078348 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.065508 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.051350 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.038528 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.026001 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.013105 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.000377 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #50
==================================================
Time       = 8479.952129
Humanoid   = Freefall
Position   = (117.260498, 38.490219, -661.649414)
Prev Vy    = 43.392139
Current Vy = 42.767143
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4072.835938, 0.000000, -1939.535400)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4072.835938, 0.000000, -1939.535400)
LookCFrame = pos=(121.483963, 44.600571, -661.991089) look=(-0.540554, -0.808933, -0.231147)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.147380, -0.808933, -1.150612)
Speed = 50.1
RelativeMoveDirection = (0.083442, -0.000000, -0.996513)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.341690 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.850372 | Pos=(133.958450, 20.995316, -659.089600)
age=+0.330454 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.318827 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.307449 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.295641 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.282962 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.270963 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.258870 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.246167 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.234233 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.222419 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.210220 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.198639 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.185564 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.172192 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.157401 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.143898 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.131340 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.117978 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.104654 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.091491 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.078650 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.064493 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.051671 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.039144 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.026247 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.013519 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.000311 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #51
==================================================
Time       = 8479.965482
Humanoid   = Freefall
Position   = (116.704018, 39.019600, -661.938354)
Prev Vy    = 42.767143
Current Vy = 42.142147
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-4006.648438, 0.000000, -2080.624512)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-4006.648438, 0.000000, -2080.624512)
LookCFrame = pos=(120.937202, 45.137764, -662.133728) look=(-0.532245, -0.808933, -0.249686)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.107537, -0.808933, -1.155017)
Speed = 50.1
RelativeMoveDirection = (0.074792, -0.000000, -0.997199)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.343836 | Heartbeat   | HumanoidState=Freefall  | Vy=+59.225376 | Pos=(133.354156, 21.738237, -659.224548)
age=+0.332210 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.320832 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.309024 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.296345 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.284346 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.272252 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.259550 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.247616 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.235801 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.223602 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.212022 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.198947 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.185575 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.170784 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.157281 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.144723 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.131360 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.118037 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.104874 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.092033 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.077875 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.065053 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.052526 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.039630 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.026902 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.013694 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.000363 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #52
==================================================
Time       = 8479.980113
Humanoid   = Freefall
Position   = (115.990120, 39.713287, -662.374146)
Prev Vy    = 42.142147
Current Vy = 41.308819
Delta Vy   = -0.833328
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-3854.966553, 0.000000, -2353.230957)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-3854.966553, 0.000000, -2353.230957)
LookCFrame = pos=(120.405396, 45.667145, -662.167603) look=(-0.513731, -0.808933, -0.285847)
MoveDirection = (1.000000, 0.000000, -1.000000)
GlobalMoveDirection = (-0.027515, -0.808933, -1.159685)
Speed = 50.1
RelativeMoveDirection = (0.109188, -0.000000, -0.994021)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.346818 | Heartbeat   | HumanoidState=Freefall  | Vy=+58.600380 | Pos=(132.743362, 22.473347, -659.329285)
age=+0.335439 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.323632 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.310952 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.298953 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.286860 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.274157 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.262223 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.250409 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.238210 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.226630 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.213554 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.200182 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.185392 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.171888 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.159330 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.145968 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.132644 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.119481 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.106641 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.092483 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.079661 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.067134 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.054238 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.041510 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.028302 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.014971 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.000351 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #53
==================================================
Time       = 8479.993516
Humanoid   = Freefall
Position   = (115.485046, 40.224442, -662.745850)
Prev Vy    = 41.308819
Current Vy = 40.683823
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-3636.603271, 0.000000, -2676.454590)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-3636.603271, 0.000000, -2676.454590)
LookCFrame = pos=(119.690102, 46.366222, -662.288147) look=(-0.485991, -0.809948, -0.328326)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.559803, 0.000000, -0.828626)
Speed = 50.1
RelativeMoveDirection = (0.126339, -0.000000, -0.991987)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.348833 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.975384 | Pos=(132.129639, 23.200642, -659.418274)
age=+0.337025 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.324346 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.312347 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.300254 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.287551 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.275617 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.263803 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.251604 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.240023 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.226948 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.213576 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.198785 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.185282 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.172724 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.159362 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.146038 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.132875 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.120035 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.105877 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.093055 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.080528 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.067631 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.054903 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.041695 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.028364 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.013745 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.000304 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #54
==================================================
Time       = 8480.005801
Humanoid   = Freefall
Position   = (114.979973, 40.727779, -663.117554)
Prev Vy    = 40.683823
Current Vy = 40.058826
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-3636.603271, 0.000000, -2676.454590)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-3636.603271, 0.000000, -2676.454590)
LookCFrame = pos=(119.185028, 46.877377, -662.659851) look=(-0.485991, -0.809948, -0.328326)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.559803, 0.000000, -0.828626)
Speed = 50.1
RelativeMoveDirection = (0.040267, -0.000000, -0.999189)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.349308 | Heartbeat   | HumanoidState=Freefall  | Vy=+57.558720 | Pos=(131.718689, 23.681166, -659.466248)
age=+0.336629 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.324630 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.312536 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.299833 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.287900 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.276085 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.263886 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.252306 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.239230 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.225858 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.211068 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.197565 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.185007 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.171644 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.158321 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.145158 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.132317 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.118159 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.105337 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.092810 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.079914 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.067186 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.053978 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.040647 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.026028 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.012587 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
age=+0.000293 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.058826 | Pos=(114.979973, 40.727779, -663.117554)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #55
==================================================
Time       = 8480.017785
Humanoid   = Freefall
Position   = (114.501564, 41.223305, -663.523499)
Prev Vy    = 40.058826
Current Vy = 39.433830
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-3444.500977, 0.000000, -2922.315186)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-3444.500977, 0.000000, -2922.315186)
LookCFrame = pos=(118.658157, 47.386086, -662.781738) look=(-0.461053, -0.810960, -0.360242)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.615691, 0.000000, -0.787988)
Speed = 50.1
RelativeMoveDirection = (0.109193, -0.000000, -0.994021)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.348598 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.933723 | Pos=(131.100159, 24.395443, -659.522278)
age=+0.336599 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.324506 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.311803 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.299869 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.288055 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.275856 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.264275 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.251200 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.237828 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.223037 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.209534 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.196976 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.183614 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.170290 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.157127 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.144286 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.130129 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.117307 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.104780 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.091883 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.079155 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.065947 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.052616 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.037997 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.024556 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
age=+0.012262 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.058826 | Pos=(114.979973, 40.727779, -663.117554)
age=+0.000313 | Heartbeat   | HumanoidState=Freefall  | Vy=+39.433830 | Pos=(114.501564, 41.223305, -663.523499)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #56
==================================================
Time       = 8480.030432
Humanoid   = Freefall
Position   = (114.023155, 41.711021, -663.929443)
Prev Vy    = 39.433830
Current Vy = 38.808834
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-3444.500977, 0.000000, -2922.315186)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-3444.500977, 0.000000, -2922.315186)
LookCFrame = pos=(118.179749, 47.881615, -663.187683) look=(-0.461053, -0.810960, -0.360242)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.615691, 0.000000, -0.787988)
Speed = 50.1
RelativeMoveDirection = (0.040262, -0.000000, -0.999189)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.349261 | Heartbeat   | HumanoidState=Freefall  | Vy=+56.308727 | Pos=(130.480026, 25.101906, -659.563477)
age=+0.337168 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.683731 | Pos=(129.858932, 25.800556, -659.593872)
age=+0.324465 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.312531 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.300717 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.288518 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.276937 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.263862 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.250490 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.235699 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.222196 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.209638 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.196275 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.182952 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.169789 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.156948 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.142790 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.129969 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.117442 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.104545 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.091817 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.078609 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.065278 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.050659 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.037218 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
age=+0.024924 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.058826 | Pos=(114.979973, 40.727779, -663.117554)
age=+0.012975 | Heartbeat   | HumanoidState=Freefall  | Vy=+39.433830 | Pos=(114.501564, 41.223305, -663.523499)
age=+0.000323 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.808834 | Pos=(114.023155, 41.711021, -663.929443)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #57
==================================================
Time       = 8480.043634
Humanoid   = Freefall
Position   = (113.578461, 42.190922, -664.372009)
Prev Vy    = 38.808834
Current Vy = 38.183838
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-3201.746826, 0.000000, -3186.714355)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-3201.746826, 0.000000, -3186.714355)
LookCFrame = pos=(117.656502, 48.374691, -663.308655) look=(-0.429962, -0.811970, -0.394763)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.676312, 0.000000, -0.736615)
Speed = 50.1
RelativeMoveDirection = (0.119492, -0.000000, -0.992835)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.337673 | Heartbeat   | HumanoidState=Freefall  | Vy=+55.058735 | Pos=(129.237564, 26.491396, -659.621155)
age=+0.325739 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.313925 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.301726 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.290146 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.277070 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.263698 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.248908 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.235404 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.222846 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.209484 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.196160 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.182997 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.170157 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.155999 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.143177 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.130650 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.117754 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.105026 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.091818 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.078487 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.063867 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.050426 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
age=+0.038133 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.058826 | Pos=(114.979973, 40.727779, -663.117554)
age=+0.026183 | Heartbeat   | HumanoidState=Freefall  | Vy=+39.433830 | Pos=(114.501564, 41.223305, -663.523499)
age=+0.013531 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.808834 | Pos=(114.023155, 41.711021, -663.929443)
age=+0.000335 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.183838 | Pos=(113.578461, 42.190922, -664.372009)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #58
==================================================
Time       = 8480.056749
Humanoid   = Freefall
Position   = (113.151344, 42.663010, -664.832336)
Prev Vy    = 38.183838
Current Vy = 37.558842
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-3075.208984, 0.000000, -3313.991211)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-3075.208984, 0.000000, -3313.991211)
LookCFrame = pos=(117.177940, 48.859932, -663.613647) look=(-0.412943, -0.812977, -0.410545)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.705045, 0.000000, -0.709163)
Speed = 50.2
RelativeMoveDirection = (0.079889, -0.000000, -0.996804)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.338856 | Heartbeat   | HumanoidState=Freefall  | Vy=+54.433739 | Pos=(128.615326, 27.174421, -659.634521)
age=+0.327042 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.314843 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.303262 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.290187 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.276815 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.262024 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.248521 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.235963 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.222601 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.209277 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.196114 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.183273 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.169116 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.156294 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.143767 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.130870 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.118142 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.104934 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.091603 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.076984 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.063543 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
age=+0.051249 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.058826 | Pos=(114.979973, 40.727779, -663.117554)
age=+0.039300 | Heartbeat   | HumanoidState=Freefall  | Vy=+39.433830 | Pos=(114.501564, 41.223305, -663.523499)
age=+0.026648 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.808834 | Pos=(114.023155, 41.711021, -663.929443)
age=+0.013451 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.183838 | Pos=(113.578461, 42.190922, -664.372009)
age=+0.000339 | Heartbeat   | HumanoidState=Freefall  | Vy=+37.558842 | Pos=(113.151344, 42.663010, -664.832336)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #59
==================================================
Time       = 8480.069786
Humanoid   = Freefall
Position   = (112.750023, 43.127289, -665.315918)
Prev Vy    = 37.558842
Current Vy = 36.933846
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-2889.476318, 0.000000, -3481.218750)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-2889.476318, 0.000000, -3481.218750)
LookCFrame = pos=(116.703407, 49.332020, -663.876221) look=(-0.389623, -0.812977, -0.432738)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.743158, 0.000000, -0.669116)
Speed = 50.2
RelativeMoveDirection = (0.095364, -0.000000, -0.995442)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.340107 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.808743 | Pos=(127.992989, 27.849634, -659.645691)
age=+0.327908 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.316328 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.303252 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.289880 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.275090 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.261586 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.249028 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.235666 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.222342 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.209179 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.196339 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.182181 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.169359 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.156832 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.143936 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.131208 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.118000 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.104669 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.090049 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.076608 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
age=+0.064315 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.058826 | Pos=(114.979973, 40.727779, -663.117554)
age=+0.052365 | Heartbeat   | HumanoidState=Freefall  | Vy=+39.433830 | Pos=(114.501564, 41.223305, -663.523499)
age=+0.039713 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.808834 | Pos=(114.023155, 41.711021, -663.929443)
age=+0.026517 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.183838 | Pos=(113.578461, 42.190922, -664.372009)
age=+0.013405 | Heartbeat   | HumanoidState=Freefall  | Vy=+37.558842 | Pos=(113.151344, 42.663010, -664.832336)
age=+0.000357 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.933846 | Pos=(112.750023, 43.127289, -665.315918)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #60
==================================================
Time       = 8480.081101
Humanoid   = Freefall
Position   = (112.362778, 43.583755, -665.811401)
Prev Vy    = 36.933846
Current Vy = 36.308849
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-2788.184082, 0.000000, -3567.168945)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-2788.184082, 0.000000, -3567.168945)
LookCFrame = pos=(116.272476, 49.796299, -664.255920) look=(-0.376746, -0.812977, -0.443994)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.762489, 0.000000, -0.647001)
Speed = 50.3
RelativeMoveDirection = (0.069501, -0.000000, -0.997582)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.339201 | Heartbeat   | HumanoidState=Freefall  | Vy=+53.183746 | Pos=(127.370476, 28.517036, -659.653564)
age=+0.327621 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.314545 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.301173 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.286383 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.272880 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.260322 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.246959 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.233636 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.220473 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.207632 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.193474 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.180652 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.168125 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.155229 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.142501 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.129293 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.115962 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.101343 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.087902 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
age=+0.075608 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.058826 | Pos=(114.979973, 40.727779, -663.117554)
age=+0.063658 | Heartbeat   | HumanoidState=Freefall  | Vy=+39.433830 | Pos=(114.501564, 41.223305, -663.523499)
age=+0.051006 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.808834 | Pos=(114.023155, 41.711021, -663.929443)
age=+0.037810 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.183838 | Pos=(113.578461, 42.190922, -664.372009)
age=+0.024698 | Heartbeat   | HumanoidState=Freefall  | Vy=+37.558842 | Pos=(113.151344, 42.663010, -664.832336)
age=+0.011650 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.933846 | Pos=(112.750023, 43.127289, -665.315918)
age=+0.000343 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.308849 | Pos=(112.362778, 43.583755, -665.811401)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #61
==================================================
Time       = 8480.093986
Humanoid   = Freefall
Position   = (111.989952, 44.032406, -666.318420)
Prev Vy    = 36.308849
Current Vy = 35.683853
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-2684.333496, 0.000000, -3650.169189)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-2684.333496, 0.000000, -3650.169189)
LookCFrame = pos=(115.852577, 50.252766, -664.648376) look=(-0.363543, -0.812977, -0.454868)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.781163, 0.000000, -0.624328)
Speed = 50.3
RelativeMoveDirection = (0.069481, -0.000000, -0.997583)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.340543 | Heartbeat   | HumanoidState=Freefall  | Vy=+52.558750 | Pos=(126.747963, 29.176624, -659.661438)
age=+0.327468 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.314096 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.299306 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.285802 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.273244 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.259882 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.246558 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.233395 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.220555 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.206397 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.193575 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.181048 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.168152 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.155423 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.142216 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.128885 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.114265 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.100824 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
age=+0.088531 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.058826 | Pos=(114.979973, 40.727779, -663.117554)
age=+0.076581 | Heartbeat   | HumanoidState=Freefall  | Vy=+39.433830 | Pos=(114.501564, 41.223305, -663.523499)
age=+0.063929 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.808834 | Pos=(114.023155, 41.711021, -663.929443)
age=+0.050732 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.183838 | Pos=(113.578461, 42.190922, -664.372009)
age=+0.037620 | Heartbeat   | HumanoidState=Freefall  | Vy=+37.558842 | Pos=(113.151344, 42.663010, -664.832336)
age=+0.024573 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.933846 | Pos=(112.750023, 43.127289, -665.315918)
age=+0.013266 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.308849 | Pos=(112.362778, 43.583755, -665.811401)
age=+0.000372 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.683853 | Pos=(111.989952, 44.032406, -666.318420)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #62
==================================================
Time       = 8480.107379
Humanoid   = Freefall
Position   = (111.628365, 44.473248, -666.834045)
Prev Vy    = 35.683853
Current Vy = 35.058857
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-2603.458740, 0.000000, -3711.881592)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-2603.458740, 0.000000, -3711.881592)
LookCFrame = pos=(115.452751, 50.701416, -665.077271) look=(-0.353235, -0.812977, -0.462918)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.794988, 0.000000, -0.606625)
Speed = 50.3
RelativeMoveDirection = (0.062560, -0.000000, -0.998041)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.340835 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.933754 | Pos=(126.125450, 29.828400, -659.669312)
age=+0.327463 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.312673 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.299169 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.286612 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.273249 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.259925 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.246762 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.233922 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.219764 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.206942 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.194415 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.181519 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.168791 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.155583 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.142252 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.127632 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.114191 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
age=+0.101898 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.058826 | Pos=(114.979973, 40.727779, -663.117554)
age=+0.089948 | Heartbeat   | HumanoidState=Freefall  | Vy=+39.433830 | Pos=(114.501564, 41.223305, -663.523499)
age=+0.077296 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.808834 | Pos=(114.023155, 41.711021, -663.929443)
age=+0.064100 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.183838 | Pos=(113.578461, 42.190922, -664.372009)
age=+0.050988 | Heartbeat   | HumanoidState=Freefall  | Vy=+37.558842 | Pos=(113.151344, 42.663010, -664.832336)
age=+0.037940 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.933846 | Pos=(112.750023, 43.127289, -665.315918)
age=+0.026633 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.308849 | Pos=(112.362778, 43.583755, -665.811401)
age=+0.013739 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.683853 | Pos=(111.989952, 44.032406, -666.318420)
age=+0.000346 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.058857 | Pos=(111.628365, 44.473248, -666.834045)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #63
==================================================
Time       = 8480.120879
Humanoid   = Freefall
Position   = (111.160286, 45.048882, -667.531799)
Prev Vy    = 35.058857
Current Vy = 34.225529
Delta Vy   = -0.833328
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-2527.592285, 0.000000, -3767.321777)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-2527.592285, 0.000000, -3767.321777)
LookCFrame = pos=(115.064690, 51.142258, -665.521423) look=(-0.343561, -0.812977, -0.470142)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.807395, 0.000000, -0.590012)
Speed = 50.4
RelativeMoveDirection = (0.060814, -0.000000, -0.998149)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.340949 | Heartbeat   | HumanoidState=Freefall  | Vy=+51.308758 | Pos=(125.502937, 30.472364, -659.677185)
age=+0.326159 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.312656 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.300098 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.286735 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.273412 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.260249 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.247408 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.233250 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.220428 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.207901 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.195005 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.182277 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.169069 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.155738 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.141119 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.127678 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
age=+0.115384 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.058826 | Pos=(114.979973, 40.727779, -663.117554)
age=+0.103434 | Heartbeat   | HumanoidState=Freefall  | Vy=+39.433830 | Pos=(114.501564, 41.223305, -663.523499)
age=+0.090782 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.808834 | Pos=(114.023155, 41.711021, -663.929443)
age=+0.077586 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.183838 | Pos=(113.578461, 42.190922, -664.372009)
age=+0.064474 | Heartbeat   | HumanoidState=Freefall  | Vy=+37.558842 | Pos=(113.151344, 42.663010, -664.832336)
age=+0.051426 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.933846 | Pos=(112.750023, 43.127289, -665.315918)
age=+0.040119 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.308849 | Pos=(112.362778, 43.583755, -665.811401)
age=+0.027225 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.683853 | Pos=(111.989952, 44.032406, -666.318420)
age=+0.013832 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.058857 | Pos=(111.628365, 44.473248, -666.834045)
age=+0.000342 | Heartbeat   | HumanoidState=Freefall  | Vy=+34.225529 | Pos=(111.160286, 45.048882, -667.531799)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #64
==================================================
Time       = 8480.133616
Humanoid   = Freefall
Position   = (110.835617, 45.471493, -668.072327)
Prev Vy    = 34.225529
Current Vy = 33.600533
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-2337.604736, 0.000000, -3892.057861)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-2337.604736, 0.000000, -3892.057861)
LookCFrame = pos=(114.526550, 51.717892, -666.048645) look=(-0.319582, -0.812977, -0.486760)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.835933, 0.000000, -0.548831)
Speed = 50.4
RelativeMoveDirection = (0.090074, -0.000000, -0.995935)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.338883 | Heartbeat   | HumanoidState=Freefall  | Vy=+50.683762 | Pos=(124.884041, 31.108515, -659.742004)
age=+0.325380 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.312822 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.299459 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.286136 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.272973 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.260132 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.245974 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.233153 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.220626 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.207729 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.195001 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.181793 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.168462 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.153843 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.140402 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
age=+0.128108 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.058826 | Pos=(114.979973, 40.727779, -663.117554)
age=+0.116159 | Heartbeat   | HumanoidState=Freefall  | Vy=+39.433830 | Pos=(114.501564, 41.223305, -663.523499)
age=+0.103507 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.808834 | Pos=(114.023155, 41.711021, -663.929443)
age=+0.090310 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.183838 | Pos=(113.578461, 42.190922, -664.372009)
age=+0.077198 | Heartbeat   | HumanoidState=Freefall  | Vy=+37.558842 | Pos=(113.151344, 42.663010, -664.832336)
age=+0.064151 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.933846 | Pos=(112.750023, 43.127289, -665.315918)
age=+0.052844 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.308849 | Pos=(112.362778, 43.583755, -665.811401)
age=+0.039950 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.683853 | Pos=(111.989952, 44.032406, -666.318420)
age=+0.026557 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.058857 | Pos=(111.628365, 44.473248, -666.834045)
age=+0.013066 | Heartbeat   | HumanoidState=Freefall  | Vy=+34.225529 | Pos=(111.160286, 45.048882, -667.531799)
age=+0.000309 | Heartbeat   | HumanoidState=Freefall  | Vy=+33.600533 | Pos=(110.835617, 45.471493, -668.072327)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #65
==================================================
Time       = 8480.145959
Humanoid   = Freefall
Position   = (110.525780, 45.886292, -668.622009)
Prev Vy    = 33.600533
Current Vy = 32.975536
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-2230.857910, 0.000000, -3957.993408)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-2230.857910, 0.000000, -3957.993408)
LookCFrame = pos=(114.159599, 52.140503, -666.496704) look=(-0.306005, -0.812977, -0.495409)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.850785, 0.000000, -0.525514)
Speed = 50.4
RelativeMoveDirection = (0.067642, -0.000000, -0.997710)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.337709 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.850433 | Pos=(124.059242, 31.944563, -659.834045)
age=+0.325152 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.311789 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.298465 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.285302 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.272462 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.258304 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.245482 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.232955 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.220059 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.207331 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.194123 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.180792 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.166172 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.152731 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
age=+0.140438 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.058826 | Pos=(114.979973, 40.727779, -663.117554)
age=+0.128488 | Heartbeat   | HumanoidState=Freefall  | Vy=+39.433830 | Pos=(114.501564, 41.223305, -663.523499)
age=+0.115836 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.808834 | Pos=(114.023155, 41.711021, -663.929443)
age=+0.102640 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.183838 | Pos=(113.578461, 42.190922, -664.372009)
age=+0.089528 | Heartbeat   | HumanoidState=Freefall  | Vy=+37.558842 | Pos=(113.151344, 42.663010, -664.832336)
age=+0.076480 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.933846 | Pos=(112.750023, 43.127289, -665.315918)
age=+0.065173 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.308849 | Pos=(112.362778, 43.583755, -665.811401)
age=+0.052279 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.683853 | Pos=(111.989952, 44.032406, -666.318420)
age=+0.038886 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.058857 | Pos=(111.628365, 44.473248, -666.834045)
age=+0.025395 | Heartbeat   | HumanoidState=Freefall  | Vy=+34.225529 | Pos=(111.160286, 45.048882, -667.531799)
age=+0.012638 | Heartbeat   | HumanoidState=Freefall  | Vy=+33.600533 | Pos=(110.835617, 45.471493, -668.072327)
age=+0.000303 | Heartbeat   | HumanoidState=Freefall  | Vy=+32.975536 | Pos=(110.525780, 45.886292, -668.622009)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #66
==================================================
Time       = 8480.159555
Humanoid   = Freefall
Position   = (110.236794, 46.293278, -669.183594)
Prev Vy    = 32.975536
Current Vy = 32.350540
Delta Vy   = -0.624996
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-2080.618652, 0.000000, -4043.080811)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-2080.618652, 0.000000, -4043.080811)
LookCFrame = pos=(113.787476, 52.555302, -666.921204) look=(-0.286956, -0.812977, -0.506680)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.870142, 0.000000, -0.492801)
Speed = 50.5
RelativeMoveDirection = (0.077956, -0.000000, -0.996957)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.338816 | Heartbeat   | HumanoidState=Freefall  | Vy=+49.225437 | Pos=(123.440895, 32.562485, -659.906372)
age=+0.325453 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.312130 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.298967 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.286126 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.271968 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.259146 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.246619 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.233723 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.220995 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.207787 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.194456 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.179837 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.166396 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
age=+0.154102 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.058826 | Pos=(114.979973, 40.727779, -663.117554)
age=+0.142152 | Heartbeat   | HumanoidState=Freefall  | Vy=+39.433830 | Pos=(114.501564, 41.223305, -663.523499)
age=+0.129501 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.808834 | Pos=(114.023155, 41.711021, -663.929443)
age=+0.116304 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.183838 | Pos=(113.578461, 42.190922, -664.372009)
age=+0.103192 | Heartbeat   | HumanoidState=Freefall  | Vy=+37.558842 | Pos=(113.151344, 42.663010, -664.832336)
age=+0.090145 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.933846 | Pos=(112.750023, 43.127289, -665.315918)
age=+0.078837 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.308849 | Pos=(112.362778, 43.583755, -665.811401)
age=+0.065943 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.683853 | Pos=(111.989952, 44.032406, -666.318420)
age=+0.052550 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.058857 | Pos=(111.628365, 44.473248, -666.834045)
age=+0.039060 | Heartbeat   | HumanoidState=Freefall  | Vy=+34.225529 | Pos=(111.160286, 45.048882, -667.531799)
age=+0.026303 | Heartbeat   | HumanoidState=Freefall  | Vy=+33.600533 | Pos=(110.835617, 45.471493, -668.072327)
age=+0.013967 | Heartbeat   | HumanoidState=Freefall  | Vy=+32.975536 | Pos=(110.525780, 45.886292, -668.622009)
age=+0.000407 | Heartbeat   | HumanoidState=Freefall  | Vy=+32.350540 | Pos=(110.236794, 46.293278, -669.183594)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #67
==================================================
Time       = 8480.172574
Humanoid   = Freefall
Position   = (109.951630, 46.692451, -669.747192)
Prev Vy    = 32.350540
Current Vy = 31.725540
Delta Vy   = -0.625000
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-2053.184814, 0.000000, -4058.368408)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-2053.184814, 0.000000, -4058.368408)
LookCFrame = pos=(113.486664, 52.962288, -667.460327) look=(-0.283447, -0.812977, -0.508651)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.873527, 0.000000, -0.486775)
Speed = 50.5
RelativeMoveDirection = (0.046903, -0.000000, -0.998899)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.338428 | Heartbeat   | HumanoidState=Freefall  | Vy=+48.600441 | Pos=(122.823669, 33.172596, -659.990417)
age=+0.325105 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.311942 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.299101 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.284943 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.272121 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.259594 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.246698 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.233970 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.220762 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.207431 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.192812 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.179371 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
age=+0.167077 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.058826 | Pos=(114.979973, 40.727779, -663.117554)
age=+0.155128 | Heartbeat   | HumanoidState=Freefall  | Vy=+39.433830 | Pos=(114.501564, 41.223305, -663.523499)
age=+0.142476 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.808834 | Pos=(114.023155, 41.711021, -663.929443)
age=+0.129279 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.183838 | Pos=(113.578461, 42.190922, -664.372009)
age=+0.116167 | Heartbeat   | HumanoidState=Freefall  | Vy=+37.558842 | Pos=(113.151344, 42.663010, -664.832336)
age=+0.103120 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.933846 | Pos=(112.750023, 43.127289, -665.315918)
age=+0.091812 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.308849 | Pos=(112.362778, 43.583755, -665.811401)
age=+0.078918 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.683853 | Pos=(111.989952, 44.032406, -666.318420)
age=+0.065525 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.058857 | Pos=(111.628365, 44.473248, -666.834045)
age=+0.052035 | Heartbeat   | HumanoidState=Freefall  | Vy=+34.225529 | Pos=(111.160286, 45.048882, -667.531799)
age=+0.039278 | Heartbeat   | HumanoidState=Freefall  | Vy=+33.600533 | Pos=(110.835617, 45.471493, -668.072327)
age=+0.026942 | Heartbeat   | HumanoidState=Freefall  | Vy=+32.975536 | Pos=(110.525780, 45.886292, -668.622009)
age=+0.013382 | Heartbeat   | HumanoidState=Freefall  | Vy=+32.350540 | Pos=(110.236794, 46.293278, -669.183594)
age=+0.000332 | Heartbeat   | HumanoidState=Freefall  | Vy=+31.725540 | Pos=(109.951630, 46.692451, -669.747192)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #68
==================================================
Time       = 8480.185453
Humanoid   = Freefall
Position   = (109.678024, 47.083813, -670.317017)
Prev Vy    = 31.725540
Current Vy = 31.100538
Delta Vy   = -0.625002
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-1969.911621, 0.000000, -4102.535156)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-1969.911621, 0.000000, -4102.535156)
LookCFrame = pos=(113.169258, 53.356121, -667.949036) look=(-0.273498, -0.811970, -0.515659)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.883432, 0.000000, -0.468560)
Speed = 50.5
RelativeMoveDirection = (0.060694, -0.000000, -0.998156)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.337982 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.975445 | Pos=(122.207245, 33.774895, -660.081970)
age=+0.324819 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.311978 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.297820 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.284998 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.272471 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.259575 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.246847 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.233639 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.220308 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.205689 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.192248 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
age=+0.179954 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.058826 | Pos=(114.979973, 40.727779, -663.117554)
age=+0.168004 | Heartbeat   | HumanoidState=Freefall  | Vy=+39.433830 | Pos=(114.501564, 41.223305, -663.523499)
age=+0.155352 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.808834 | Pos=(114.023155, 41.711021, -663.929443)
age=+0.142156 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.183838 | Pos=(113.578461, 42.190922, -664.372009)
age=+0.129044 | Heartbeat   | HumanoidState=Freefall  | Vy=+37.558842 | Pos=(113.151344, 42.663010, -664.832336)
age=+0.115996 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.933846 | Pos=(112.750023, 43.127289, -665.315918)
age=+0.104689 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.308849 | Pos=(112.362778, 43.583755, -665.811401)
age=+0.091795 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.683853 | Pos=(111.989952, 44.032406, -666.318420)
age=+0.078402 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.058857 | Pos=(111.628365, 44.473248, -666.834045)
age=+0.064912 | Heartbeat   | HumanoidState=Freefall  | Vy=+34.225529 | Pos=(111.160286, 45.048882, -667.531799)
age=+0.052155 | Heartbeat   | HumanoidState=Freefall  | Vy=+33.600533 | Pos=(110.835617, 45.471493, -668.072327)
age=+0.039819 | Heartbeat   | HumanoidState=Freefall  | Vy=+32.975536 | Pos=(110.525780, 45.886292, -668.622009)
age=+0.026259 | Heartbeat   | HumanoidState=Freefall  | Vy=+32.350540 | Pos=(110.236794, 46.293278, -669.183594)
age=+0.013208 | Heartbeat   | HumanoidState=Freefall  | Vy=+31.725540 | Pos=(109.951630, 46.692451, -669.747192)
age=+0.000311 | Heartbeat   | HumanoidState=Freefall  | Vy=+31.100538 | Pos=(109.678024, 47.083813, -670.317017)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #69
==================================================
Time       = 8480.198324
Humanoid   = Freefall
Position   = (109.405380, 47.467361, -670.887390)
Prev Vy    = 31.100538
Current Vy = 30.475536
Delta Vy   = -0.625002
DataRegistry.State    = Air
DataRegistry.Climbing = nil
DataRegistry.Velocity = (-1962.963501, 0.000000, -4106.205078)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Air
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = false
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (-1962.963501, 0.000000, -4106.205078)
LookCFrame = pos=(112.892540, 53.747482, -668.513245) look=(-0.272607, -0.811970, -0.516131)
MoveDirection = (1.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.884240, 0.000000, -0.467033)
Speed = 50.5
RelativeMoveDirection = (0.041707, -0.000000, -0.999130)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.337696 | Heartbeat   | HumanoidState=Freefall  | Vy=+47.350449 | Pos=(121.594849, 34.369377, -660.200073)
age=+0.324855 | Heartbeat   | HumanoidState=Freefall  | Vy=+46.725452 | Pos=(120.983482, 34.956051, -660.324585)
age=+0.310697 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.892124 | Pos=(120.177025, 35.726128, -660.531372)
age=+0.297875 | Heartbeat   | HumanoidState=Freefall  | Vy=+45.267128 | Pos=(119.578636, 36.294571, -660.711548)
age=+0.285348 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.642132 | Pos=(118.983749, 36.855202, -660.904175)
age=+0.272452 | Heartbeat   | HumanoidState=Freefall  | Vy=+44.017136 | Pos=(118.402481, 37.408020, -661.135620)
age=+0.259724 | Heartbeat   | HumanoidState=Freefall  | Vy=+43.392139 | Pos=(117.826180, 37.953026, -661.380066)
age=+0.246516 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.767143 | Pos=(117.260498, 38.490219, -661.649414)
age=+0.233185 | Heartbeat   | HumanoidState=Freefall  | Vy=+42.142147 | Pos=(116.704018, 39.019600, -661.938354)
age=+0.218565 | Heartbeat   | HumanoidState=Freefall  | Vy=+41.308819 | Pos=(115.990120, 39.713287, -662.374146)
age=+0.205124 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.683823 | Pos=(115.485046, 40.224442, -662.745850)
age=+0.192831 | Heartbeat   | HumanoidState=Freefall  | Vy=+40.058826 | Pos=(114.979973, 40.727779, -663.117554)
age=+0.180881 | Heartbeat   | HumanoidState=Freefall  | Vy=+39.433830 | Pos=(114.501564, 41.223305, -663.523499)
age=+0.168229 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.808834 | Pos=(114.023155, 41.711021, -663.929443)
age=+0.155033 | Heartbeat   | HumanoidState=Freefall  | Vy=+38.183838 | Pos=(113.578461, 42.190922, -664.372009)
age=+0.141921 | Heartbeat   | HumanoidState=Freefall  | Vy=+37.558842 | Pos=(113.151344, 42.663010, -664.832336)
age=+0.128873 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.933846 | Pos=(112.750023, 43.127289, -665.315918)
age=+0.117566 | Heartbeat   | HumanoidState=Freefall  | Vy=+36.308849 | Pos=(112.362778, 43.583755, -665.811401)
age=+0.104672 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.683853 | Pos=(111.989952, 44.032406, -666.318420)
age=+0.091279 | Heartbeat   | HumanoidState=Freefall  | Vy=+35.058857 | Pos=(111.628365, 44.473248, -666.834045)
age=+0.077789 | Heartbeat   | HumanoidState=Freefall  | Vy=+34.225529 | Pos=(111.160286, 45.048882, -667.531799)
age=+0.065031 | Heartbeat   | HumanoidState=Freefall  | Vy=+33.600533 | Pos=(110.835617, 45.471493, -668.072327)
age=+0.052696 | Heartbeat   | HumanoidState=Freefall  | Vy=+32.975536 | Pos=(110.525780, 45.886292, -668.622009)
age=+0.039136 | Heartbeat   | HumanoidState=Freefall  | Vy=+32.350540 | Pos=(110.236794, 46.293278, -669.183594)
age=+0.026085 | Heartbeat   | HumanoidState=Freefall  | Vy=+31.725540 | Pos=(109.951630, 46.692451, -669.747192)
age=+0.013188 | Heartbeat   | HumanoidState=Freefall  | Vy=+31.100538 | Pos=(109.678024, 47.083813, -670.317017)
age=+0.000337 | Heartbeat   | HumanoidState=Freefall  | Vy=+30.475536 | Pos=(109.405380, 47.467361, -670.887390)
-----------------------------------------------
==================================================


========== HUMANOID STATE CHANGED ==========
Time     = 8482.268893
From     = Freefall
To       = Landed
Position = (136.929825, 3.457031, -623.264099)
Velocity = (54.523487, -72.857780, 9.798615)
============================================

========== DATAREGISTRY STATE CHANGE ==========
Time      = 8482.281654
State     = Move
Climbing  = nil
Humanoid  = Landed
Position  = (137.818436, 2.386132, -623.104431)
Velocity  = (52.109104, -37.192417, 9.364717)

==================================================
VERTICAL EVENT #70
==================================================
Time       = 8482.281760
Humanoid   = Landed
Position   = (137.818436, 2.386132, -623.104431)
Prev Vy    = -73.274452
Current Vy = -37.192417
Delta Vy   = 36.082035
DataRegistry.State    = Move
DataRegistry.Climbing = nil
DataRegistry.Velocity = (4689.821289, 0.000000, 842.824829)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Move
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = true
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (4689.821289, 0.000000, 842.824829)
LookCFrame = pos=(133.419189, 9.061077, -621.662964) look=(0.679692, -0.728550, 0.085047)
MoveDirection = (0.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.000000, 0.000000, 0.000000)
Speed = 52.9
RelativeMoveDirection = (0.053313, 0.000000, -0.998578)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.344040 | Heartbeat   | HumanoidState=Freefall  | Vy=-56.607719 | Pos=(119.457367, 24.529020, -627.266907)
age=+0.336283 | Heartbeat   | HumanoidState=Freefall  | Vy=-57.024384 | Pos=(119.874298, 24.054684, -627.075745)
age=+0.326753 | Heartbeat   | HumanoidState=Freefall  | Vy=-57.441048 | Pos=(120.294006, 23.576876, -626.890320)
age=+0.319711 | Heartbeat   | HumanoidState=Freefall  | Vy=-57.857712 | Pos=(120.715744, 23.095596, -626.709167)
age=+0.310473 | Heartbeat   | HumanoidState=Freefall  | Vy=-58.274376 | Pos=(121.139465, 22.610846, -626.532288)
age=+0.303028 | Heartbeat   | HumanoidState=Freefall  | Vy=-58.691040 | Pos=(121.567596, 22.122622, -626.365662)
age=+0.293414 | Heartbeat   | HumanoidState=Freefall  | Vy=-59.107704 | Pos=(121.999893, 21.630924, -626.209290)
age=+0.286163 | Heartbeat   | HumanoidState=Freefall  | Vy=-59.524368 | Pos=(122.436615, 21.135756, -626.064880)
age=+0.277839 | Heartbeat   | HumanoidState=Freefall  | Vy=-59.941032 | Pos=(122.877426, 20.637115, -625.932556)
age=+0.268110 | Heartbeat   | HumanoidState=Freefall  | Vy=-60.357697 | Pos=(123.321579, 20.135004, -625.810730)
age=+0.260595 | Heartbeat   | HumanoidState=Freefall  | Vy=-60.774361 | Pos=(123.767761, 19.629417, -625.695862)
age=+0.252410 | Heartbeat   | HumanoidState=Freefall  | Vy=-61.191025 | Pos=(124.215469, 19.120359, -625.586365)
age=+0.244408 | Heartbeat   | HumanoidState=Freefall  | Vy=-61.607689 | Pos=(124.666824, 18.607830, -625.491516)
age=+0.235429 | Heartbeat   | HumanoidState=Freefall  | Vy=-62.024353 | Pos=(125.118179, 18.091829, -625.396667)
age=+0.227829 | Heartbeat   | HumanoidState=Freefall  | Vy=-62.441017 | Pos=(125.570999, 17.572357, -625.308044)
age=+0.218357 | Heartbeat   | HumanoidState=Freefall  | Vy=-62.857681 | Pos=(126.024857, 17.049410, -625.224060)
age=+0.210485 | Heartbeat   | HumanoidState=Freefall  | Vy=-63.274345 | Pos=(126.479218, 16.522991, -625.142395)
age=+0.202690 | Heartbeat   | HumanoidState=Freefall  | Vy=-63.691010 | Pos=(126.933578, 15.993101, -625.060730)
age=+0.193138 | Heartbeat   | HumanoidState=Freefall  | Vy=-64.107674 | Pos=(127.387939, 15.459739, -624.979065)
age=+0.186147 | Heartbeat   | HumanoidState=Freefall  | Vy=-64.524345 | Pos=(127.842300, 14.922904, -624.897400)
age=+0.177657 | Heartbeat   | HumanoidState=Freefall  | Vy=-64.941017 | Pos=(128.296677, 14.382597, -624.815735)
age=+0.168382 | Heartbeat   | HumanoidState=Freefall  | Vy=-65.357689 | Pos=(128.751053, 13.838818, -624.734070)
age=+0.162975 | Heartbeat   | HumanoidState=Freefall  | Vy=-65.774361 | Pos=(129.205429, 13.291566, -624.652405)
age=+0.154571 | Heartbeat   | HumanoidState=Freefall  | Vy=-66.191032 | Pos=(129.659805, 12.740842, -624.570740)
age=+0.146413 | Heartbeat   | HumanoidState=Freefall  | Vy=-66.607704 | Pos=(130.114182, 12.186646, -624.489075)
age=+0.137643 | Heartbeat   | HumanoidState=Freefall  | Vy=-67.024376 | Pos=(130.568558, 11.628977, -624.407410)
age=+0.129554 | Heartbeat   | HumanoidState=Freefall  | Vy=-67.441048 | Pos=(131.022934, 11.067837, -624.325745)
age=+0.121348 | Heartbeat   | HumanoidState=Freefall  | Vy=-67.857719 | Pos=(131.477310, 10.503223, -624.244080)
age=+0.112721 | Heartbeat   | HumanoidState=Freefall  | Vy=-68.274391 | Pos=(131.931686, 9.935139, -624.162415)
age=+0.104658 | Heartbeat   | HumanoidState=Freefall  | Vy=-68.691063 | Pos=(132.386063, 9.363581, -624.080750)
age=+0.096355 | Heartbeat   | HumanoidState=Freefall  | Vy=-69.107735 | Pos=(132.840439, 8.788551, -623.999084)
age=+0.087287 | Heartbeat   | HumanoidState=Freefall  | Vy=-69.524406 | Pos=(133.294815, 8.210049, -623.917419)
age=+0.079773 | Heartbeat   | HumanoidState=Freefall  | Vy=-69.941078 | Pos=(133.749191, 7.628075, -623.835754)
age=+0.070712 | Heartbeat   | HumanoidState=Freefall  | Vy=-70.357750 | Pos=(134.203568, 7.042628, -623.754089)
age=+0.062242 | Heartbeat   | HumanoidState=Freefall  | Vy=-70.774422 | Pos=(134.657944, 6.453710, -623.672424)
age=+0.054757 | Heartbeat   | HumanoidState=Freefall  | Vy=-71.191093 | Pos=(135.112320, 5.861319, -623.590759)
age=+0.045954 | Heartbeat   | HumanoidState=Freefall  | Vy=-71.607765 | Pos=(135.566696, 5.265455, -623.509094)
age=+0.037385 | Heartbeat   | HumanoidState=Freefall  | Vy=-72.024437 | Pos=(136.021072, 4.666120, -623.427429)
age=+0.029072 | Heartbeat   | HumanoidState=Freefall  | Vy=-72.441109 | Pos=(136.475449, 4.063312, -623.345764)
age=+0.020691 | Heartbeat   | HumanoidState=Freefall  | Vy=-72.857780 | Pos=(136.929825, 3.457031, -623.264099)
age=+0.011871 | Heartbeat   | HumanoidState=Landed    | Vy=-73.274452 | Pos=(137.384201, 2.847279, -623.182434)
age=+0.000543 | Heartbeat   | HumanoidState=Landed    | Vy=-37.192417 | Pos=(137.818436, 2.386132, -623.104431)
-----------------------------------------------
==================================================


==================================================
VERTICAL EVENT #71
==================================================
Time       = 8482.299359
Humanoid   = Landed
Position   = (138.652847, 2.355159, -622.954529)
Prev Vy    = -37.192417
Current Vy = 7.405095
Delta Vy   = 44.597512
DataRegistry.State    = Move
DataRegistry.Climbing = nil
DataRegistry.Velocity = (4505.820801, 0.000000, 809.757446)
ClimbAlign = NOT FOUND

--------------- MAP CONTACTS ----------------
none
----------------------------------------------

--------------- DATAREGISTRY ----------------
State = Move
Climbing = nil
ClimbPosition = nil
ClimbWaitPosition = nil
EndingClimb = nil
Grounded = true
JumpQueued = nil
JumpingActive = true
JumpAmount = nil
Velocity = (4505.820801, 0.000000, 809.757446)
LookCFrame = pos=(133.853424, 8.599930, -621.584961) look=(0.679692, -0.728550, 0.085047)
MoveDirection = (0.000000, 0.000000, 0.000000)
GlobalMoveDirection = (0.000000, 0.000000, 0.000000)
Speed = 50.8
RelativeMoveDirection = (0.053313, 0.000000, -0.998578)
----------------------------------------------

--------------- PHYSICS HISTORY ---------------
age=+0.344387 | Heartbeat   | HumanoidState=Freefall  | Vy=-57.441048 | Pos=(120.294006, 23.576876, -626.890320)
age=+0.337346 | Heartbeat   | HumanoidState=Freefall  | Vy=-57.857712 | Pos=(120.715744, 23.095596, -626.709167)
age=+0.328107 | Heartbeat   | HumanoidState=Freefall  | Vy=-58.274376 | Pos=(121.139465, 22.610846, -626.532288)
age=+0.320663 | Heartbeat   | HumanoidState=Freefall  | Vy=-58.691040 | Pos=(121.567596, 22.122622, -626.365662)
age=+0.311048 | Heartbeat   | HumanoidState=Freefall  | Vy=-59.107704 | Pos=(121.999893, 21.630924, -626.209290)
age=+0.303797 | Heartbeat   | HumanoidState=Freefall  | Vy=-59.524368 | Pos=(122.436615, 21.135756, -626.064880)
age=+0.295473 | Heartbeat   | HumanoidState=Freefall  | Vy=-59.941032 | Pos=(122.877426, 20.637115, -625.932556)
age=+0.285744 | Heartbeat   | HumanoidState=Freefall  | Vy=-60.357697 | Pos=(123.321579, 20.135004, -625.810730)
age=+0.278229 | Heartbeat   | HumanoidState=Freefall  | Vy=-60.774361 | Pos=(123.767761, 19.629417, -625.695862)
age=+0.270045 | Heartbeat   | HumanoidState=Freefall  | Vy=-61.191025 | Pos=(124.215469, 19.120359, -625.586365)
age=+0.262042 | Heartbeat   | HumanoidState=Freefall  | Vy=-61.607689 | Pos=(124.666824, 18.607830, -625.491516)
age=+0.253063 | Heartbeat   | HumanoidState=Freefall  | Vy=-62.024353 | Pos=(125.118179, 18.091829, -625.396667)
age=+0.245463 | Heartbeat   | HumanoidState=Freefall  | Vy=-62.441017 | Pos=(125.570999, 17.572357, -625.308044)
age=+0.235992 | Heartbeat   | HumanoidState=Freefall  | Vy=-62.857681 | Pos=(126.024857, 17.049410, -625.224060)
age=+0.228119 | Heartbeat   | HumanoidState=Freefall  | Vy=-63.274345 | Pos=(126.479218, 16.522991, -625.142395)
age=+0.220325 | Heartbeat   | HumanoidState=Freefall  | Vy=-63.691010 | Pos=(126.933578, 15.993101, -625.060730)
age=+0.210772 | Heartbeat   | HumanoidState=Freefall  | Vy=-64.107674 | Pos=(127.387939, 15.459739, -624.979065)
age=+0.203782 | Heartbeat   | HumanoidState=Freefall  | Vy=-64.524345 | Pos=(127.842300, 14.922904, -624.897400)
age=+0.195291 | Heartbeat   | HumanoidState=Freefall  | Vy=-64.941017 | Pos=(128.296677, 14.382597, -624.815735)
age=+0.186016 | Heartbeat   | HumanoidState=Freefall  | Vy=-65.357689 | Pos=(128.751053, 13.838818, -624.734070)
age=+0.180609 | Heartbeat   | HumanoidState=Freefall  | Vy=-65.774361 | Pos=(129.205429, 13.291566, -624.652405)
age=+0.172205 | Heartbeat   | HumanoidState=Freefall  | Vy=-66.191032 | Pos=(129.659805, 12.740842, -624.570740)
age=+0.164048 | Heartbeat   | HumanoidState=Freefall  | Vy=-66.607704 | Pos=(130.114182, 12.186646, -624.489075)
age=+0.155278 | Heartbeat   | HumanoidState=Freefall  | Vy=-67.024376 | Pos=(130.568558, 11.628977, -624.407410)
age=+0.147188 | Heartbeat   | HumanoidState=Freefall  | Vy=-67.441048 | Pos=(131.022934, 11.067837, -624.325745)
age=+0.138982 | Heartbeat   | HumanoidState=Freefall  | Vy=-67.857719 | Pos=(131.477310, 10.503223, -624.244080)
age=+0.130355 | Heartbeat   | HumanoidState=Freefall  | Vy=-68.274391 | Pos=(131.931686, 9.935139, -624.162415)
age=+0.122293 | Heartbeat   | HumanoidState=Freefall  | Vy=-68.691063 | Pos=(132.386063, 9.363581, -624.080750)
age=+0.113989 | Heartbeat   | HumanoidState=Freefall  | Vy=-69.107735 | Pos=(132.840439, 8.788551, -623.999084)
age=+0.104922 | Heartbeat   | HumanoidState=Freefall  | Vy=-69.524406 | Pos=(133.294815, 8.210049, -623.917419)
age=+0.097408 | Heartbeat   | HumanoidState=Freefall  | Vy=-69.941078 | Pos=(133.749191, 7.628075, -623.835754)
age=+0.088347 | Heartbeat   | HumanoidState=Freefall  | Vy=-70.357750 | Pos=(134.203568, 7.042628, -623.754089)
age=+0.079876 | Heartbeat   | HumanoidState=Freefall  | Vy=-70.774422 | Pos=(134.657944, 6.453710, -623.672424)
age=+0.072391 | Heartbeat   | HumanoidState=Freefall  | Vy=-71.191093 | Pos=(135.112320, 5.861319, -623.590759)
age=+0.063588 | Heartbeat   | HumanoidState=Freefall  | Vy=-71.607765 | Pos=(135.566696, 5.265455, -623.509094)
age=+0.055020 | Heartbeat   | HumanoidState=Freefall  | Vy=-72.024437 | Pos=(136.021072, 4.666120, -623.427429)
age=+0.046706 | Heartbeat   | HumanoidState=Freefall  | Vy=-72.441109 | Pos=(136.475449, 4.063312, -623.345764)
age=+0.038326 | Heartbeat   | HumanoidState=Freefall  | Vy=-72.857780 | Pos=(136.929825, 3.457031, -623.264099)
age=+0.029505 | Heartbeat   | HumanoidState=Landed    | Vy=-73.274452 | Pos=(137.384201, 2.847279, -623.182434)
age=+0.018178 | Heartbeat   | HumanoidState=Landed    | Vy=-37.192417 | Pos=(137.818436, 2.386132, -623.104431)
age=+0.000464 | Heartbeat   | HumanoidState=Landed    | Vy=+7.405095 | Pos=(138.652847, 2.355159, -622.954529)
-----------------------------------------------
==================================================


========== HUMANOID STATE CHANGED ==========
Time     = 8482.312144
From     = Landed
To       = Running
Position = (138.652847, 2.355159, -622.954529)
Velocity = (50.064655, 7.405095, 8.997301)
============================================

========== DATAREGISTRY STATE CHANGE ==========
Time      = 8482.765207
State     = Idle
Climbing  = nil
Humanoid  = Running
Position  = (146.599640, 2.749961, -621.526306)
Velocity  = (-0.000000, 0.000020, 0.000000)

==================================================
DeadEye ClimbAlign Physics Trace STOPPED
==================================================

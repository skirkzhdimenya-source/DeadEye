============================================================
AIR-STRAFE SOURCE TRACE
============================================================
F6 = STOP + COPY
_G.DeadEyeStopAirTrace = true  -> external stop

Accelerate = function: 0x8a19bbe30a8dc915
  source = =ReplicatedStorage.Objects.Game.Character.Client.Movement.MoveFunction.Functions.Helpers
  line   = 177
  name   = Accelerate

AirControl = function: 0x7745d716b4bc874e
  source = =ReplicatedStorage.Objects.Game.Character.Client.Movement.MoveFunction.Functions.Helpers
  line   = 164
  name   = AirControl

============================================================
TRACE RUNNING
Do ONE normal jump with your usual smooth air-strafe.
Do NOT abruptly reverse direction.
Press F6 after landing.
============================================================
ACCEL #1 t=1.0477 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (223.650,0.000,23.049) mag= 224.834579
  WishDir    = (0.995,0.000,0.103) mag= 1.000000
  Accel      = 1642.835307
  WishSpeed  = 20.400000
  dt         = 0.008337
  Dot(Vel,Wish) = 224.834579
  addSpeed = -204.434579
  accelSpeed(x10) = 2794.020901
  expectedAdd = 0.000000
  RETURN     = (501.580,0.000,51.692)
  DELTA      = (277.930,0.000,28.643) mag= 279.402069
  CameraLook = (0.995,0.000,0.103) angle= 0.000000
  CameraRight= (-0.103,0.000,0.995) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.995,0.000,0.103) angle= 0.000000
  RootRight  = (-0.103,0.000,0.995) dot= 0.000004
  Wish(root basis): Right= 0.000004 Forward= 1.000000
  HumMove    = (0.995,0.000,0.103) angle= 0.000000

ACCEL #2 t=1.0560 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (451.901,0.000,46.572) mag= 454.294830
  WishDir    = (0.995,0.000,0.103) mag= 1.000000
  Accel      = 1654.393271
  WishSpeed  = 20.400000
  dt         = 0.008394
  Dot(Vel,Wish) = 454.294861
  addSpeed = -433.894861
  accelSpeed(x10) = 2832.802557
  expectedAdd = 0.000000
  RETURN     = (733.689,0.000,75.613)
  DELTA      = (281.788,0.000,29.041) mag= 283.280243
  CameraLook = (0.995,0.000,0.103) angle= 0.000000
  CameraRight= (-0.103,0.000,0.995) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.995,0.000,0.103) angle= 0.000000
  RootRight  = (-0.103,0.000,0.995) dot= 0.000008
  Wish(root basis): Right= 0.000008 Forward= 1.000000
  HumMove    = (0.995,0.000,0.103) angle= 0.000000

ACCEL #3 t=1.0645 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (683.758,0.000,70.467) mag= 687.379639
  WishDir    = (0.995,0.000,0.103) mag= 1.000000
  Accel      = 1666.009930
  WishSpeed  = 20.400000
  dt         = 0.008436
  Dot(Vel,Wish) = 687.379639
  addSpeed = -666.979639
  accelSpeed(x10) = 2867.180686
  expectedAdd = 0.000000
  RETURN     = (968.966,0.000,99.860)
  DELTA      = (285.207,0.000,29.393) mag= 286.718079
  CameraLook = (0.995,0.000,0.103) angle= 0.000000
  CameraRight= (-0.103,0.000,0.995) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.995,0.000,0.102) angle= 0.000000
  RootRight  = (-0.102,0.000,0.995) dot= 0.000016
  Wish(root basis): Right= 0.000016 Forward= 1.000000
  HumMove    = (0.995,0.000,0.103) angle= 0.000000

ACCEL #4 t=1.0727 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (920.281,0.000,94.843) mag= 925.155762
  WishDir    = (0.995,0.000,0.103) mag= 1.000000
  Accel      = 1677.336501
  WishSpeed  = 20.400000
  dt         = 0.008226
  Dot(Vel,Wish) = 925.155762
  addSpeed = -904.755762
  accelSpeed(x10) = 2814.588224
  expectedAdd = 0.000000
  RETURN     = (1200.257,0.000,123.697)
  DELTA      = (279.976,0.000,28.854) mag= 281.458862
  CameraLook = (0.995,0.000,0.103) angle= 0.000000
  CameraRight= (-0.103,0.000,0.995) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.995,0.000,0.103) angle= 0.000000
  RootRight  = (-0.103,0.000,0.995) dot= 0.000012
  Wish(root basis): Right= 0.000012 Forward= 1.000000
  HumMove    = (0.995,0.000,0.103) angle= 0.000000

ACCEL #5 t=1.0809 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (1150.803,0.000,118.600) mag= 1156.898560
  WishDir    = (0.995,0.000,0.103) mag= 1.000000
  Accel      = 1688.683784
  WishSpeed  = 20.400000
  dt         = 0.008241
  Dot(Vel,Wish) = 1156.898682
  addSpeed = -1136.498682
  accelSpeed(x10) = 2838.810853
  expectedAdd = 0.000000
  RETURN     = (1433.189,0.000,147.703)
  DELTA      = (282.385,0.000,29.102) mag= 283.881042
  CameraLook = (0.995,0.000,0.103) angle= 0.000000
  CameraRight= (-0.103,0.000,0.995) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.995,0.000,0.103) angle= 0.000000
  RootRight  = (-0.103,0.000,0.995) dot= 0.000007
  Wish(root basis): Right= 0.000007 Forward= 1.000000
  HumMove    = (0.995,0.000,0.103) angle= 0.000000

ACCEL #6 t=1.0892 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (1373.551,0.000,141.556) mag= 1380.825806
  WishDir    = (0.995,0.000,0.103) mag= 1.000000
  Accel      = 1700.143752
  WishSpeed  = 20.400000
  dt         = 0.008322
  Dot(Vel,Wish) = 1380.825806
  addSpeed = -1360.425806
  accelSpeed(x10) = 2886.458206
  expectedAdd = 0.000000
  RETURN     = (1660.676,0.000,171.147)
  DELTA      = (287.125,0.000,29.591) mag= 288.645752
  CameraLook = (0.995,0.000,0.103) angle= 0.000000
  CameraRight= (-0.103,0.000,0.995) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.995,0.000,0.103) angle= 0.000000
  RootRight  = (-0.103,0.000,0.995) dot= 0.000013
  Wish(root basis): Right= 0.000013 Forward= 1.000000
  HumMove    = (0.995,0.000,0.103) angle= 0.000000

ACCEL #7 t=1.0977 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (1590.230,0.000,163.887) mag= 1598.652588
  WishDir    = (0.995,0.000,0.103) mag= 1.000000
  Accel      = 1711.826220
  WishSpeed  = 20.400000
  dt         = 0.008484
  Dot(Vel,Wish) = 1598.652588
  addSpeed = -1578.252588
  accelSpeed(x10) = 2962.719384
  expectedAdd = 0.000000
  RETURN     = (1702.807,0.000,175.489)
  DELTA      = (112.577,0.000,11.602) mag= 113.173660
  CameraLook = (0.995,0.000,0.103) angle= 0.000000
  CameraRight= (-0.103,0.000,0.995) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.995,0.000,0.103) angle= 0.000000
  RootRight  = (-0.103,0.000,0.995) dot= 0.000013
  Wish(root basis): Right= 0.000013 Forward= 1.000000
  HumMove    = (0.995,0.000,0.103) angle= 0.000000

ACCEL #8 t=1.1066 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (1630.840,0.000,168.072) mag= 1639.477539
  WishDir    = (0.995,0.000,0.103) mag= 1.000000
  Accel      = 1723.465714
  WishSpeed  = 20.400000
  dt         = 0.008453
  Dot(Vel,Wish) = 1639.477661
  addSpeed = -1619.077661
  accelSpeed(x10) = 2971.891731
  expectedAdd = 0.000000
  RETURN     = (1714.385,0.000,176.682)
  DELTA      = (83.546,0.000,8.610) mag= 83.988037
  CameraLook = (0.995,0.000,0.103) angle= 0.000000
  CameraRight= (-0.103,0.000,0.995) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.995,0.000,0.103) angle= 0.000000
  RootRight  = (-0.103,0.000,0.995) dot= 0.000011
  Wish(root basis): Right= 0.000011 Forward= 1.000000
  HumMove    = (0.995,0.000,0.103) angle= 0.000000

ACCEL #9 t=1.1145 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (1646.620,0.000,169.699) mag= 1655.341675
  WishDir    = (0.995,0.000,0.103) mag= 1.000000
  Accel      = 1734.351530
  WishSpeed  = 20.400000
  dt         = 0.007905
  Dot(Vel,Wish) = 1655.341797
  addSpeed = -1634.941797
  accelSpeed(x10) = 2797.012044
  expectedAdd = 0.000000
  RETURN     = (1725.214,0.000,177.798)
  DELTA      = (78.594,0.000,8.100) mag= 79.009781
  CameraLook = (0.995,0.000,0.103) angle= 0.000000
  CameraRight= (-0.103,0.000,0.995) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.995,0.000,0.103) angle= 0.000000
  RootRight  = (-0.103,0.000,0.995) dot= 0.000010
  Wish(root basis): Right= 0.000010 Forward= 1.000000
  HumMove    = (0.995,0.000,0.103) angle= 0.000000

ACCEL #10 t=1.1226 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (1653.778,0.000,170.436) mag= 1662.537476
  WishDir    = (0.994,0.000,0.105) mag= 1.000000
  Accel      = 1745.754984
  WishSpeed  = 20.400000
  dt         = 0.008281
  Dot(Vel,Wish) = 1662.533203
  addSpeed = -1642.133203
  accelSpeed(x10) = 2949.279443
  expectedAdd = 0.000000
  RETURN     = (1736.542,0.000,179.159)
  DELTA      = (82.763,0.000,8.722) mag= 83.221786
  CameraLook = (0.994,0.000,0.105) angle= 0.000000
  CameraRight= (-0.105,0.000,0.994) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.995,0.000,0.103) angle= 0.128204
  RootRight  = (-0.103,0.000,0.995) dot= 0.002315
  Wish(root basis): Right= 0.002315 Forward= 0.999997
  HumMove    = (0.995,0.000,0.103) angle= 0.131221

ACCEL #11 t=1.1309 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (1664.166,0.000,171.692) mag= 1672.999512
  WishDir    = (0.994,0.000,0.108) mag= 1.000000
  Accel      = 1757.233082
  WishSpeed  = 20.400000
  dt         = 0.008336
  Dot(Vel,Wish) = 1672.972900
  addSpeed = -1652.572900
  accelSpeed(x10) = 2988.102658
  expectedAdd = 0.000000
  RETURN     = (1747.931,0.000,180.813)
  DELTA      = (83.765,0.000,9.121) mag= 84.260132
  CameraLook = (0.994,0.000,0.108) angle= 0.000000
  CameraRight= (-0.108,0.000,0.994) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.994,0.000,0.105) angle= 0.197824
  RootRight  = (-0.105,0.000,0.994) dot= 0.003468
  Wish(root basis): Right= 0.003468 Forward= 0.999994
  HumMove    = (0.994,0.000,0.105) angle= 0.197824

ACCEL #12 t=1.1393 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (1675.363,0.000,173.306) mag= 1684.303101
  WishDir    = (0.994,0.000,0.112) mag= 1.000000
  Accel      = 1768.666715
  WishSpeed  = 20.400000
  dt         = 0.008303
  Dot(Vel,Wish) = 1684.237305
  addSpeed = -1663.837305
  accelSpeed(x10) = 2995.894296
  expectedAdd = 0.000000
  RETURN     = (1759.265,0.000,182.736)
  DELTA      = (83.901,0.000,9.430) mag= 84.429466
  CameraLook = (0.994,0.000,0.112) angle= 0.000000
  CameraRight= (-0.112,0.000,0.994) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.994,0.000,0.108) angle= 0.198810
  RootRight  = (-0.108,0.000,0.994) dot= 0.003468
  Wish(root basis): Right= 0.003468 Forward= 0.999994
  HumMove    = (0.994,0.000,0.108) angle= 0.198810

ACCEL #13 t=1.1475 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (1685.982,0.000,175.124) mag= 1695.052734
  WishDir    = (0.993,0.000,0.115) mag= 1.000000
  Accel      = 1780.138559
  WishSpeed  = 20.400000
  dt         = 0.008331
  Dot(Vel,Wish) = 1694.933105
  addSpeed = -1674.533105
  accelSpeed(x10) = 3025.403379
  expectedAdd = 0.000000
  RETURN     = (1770.621,0.000,184.933)
  DELTA      = (84.639,0.000,9.809) mag= 85.205414
  CameraLook = (0.993,0.000,0.115) angle= 0.000000
  CameraRight= (-0.115,0.000,0.993) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.994,0.000,0.112) angle= 0.198810
  RootRight  = (-0.112,0.000,0.994) dot= 0.003468
  Wish(root basis): Right= 0.003468 Forward= 0.999994
  HumMove    = (0.994,0.000,0.112) angle= 0.198810

ACCEL #14 t=1.1560 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (1696.715,0.000,177.214) mag= 1705.944702
  WishDir    = (0.993,0.000,0.119) mag= 1.000000
  Accel      = 1791.633756
  WishSpeed  = 20.400000
  dt         = 0.008348
  Dot(Vel,Wish) = 1705.758667
  addSpeed = -1685.358667
  accelSpeed(x10) = 3051.138039
  expectedAdd = 0.000000
  RETURN     = (1781.985,0.000,187.395)
  DELTA      = (85.269,0.000,10.181) mag= 85.875053
  CameraLook = (0.993,0.000,0.119) angle= 0.000000
  CameraRight= (-0.119,0.000,0.993) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.993,0.000,0.115) angle= 0.197824
  RootRight  = (-0.115,0.000,0.993) dot= 0.003468
  Wish(root basis): Right= 0.003468 Forward= 0.999994
  HumMove    = (0.993,0.000,0.115) angle= 0.197824

ACCEL #15 t=1.1644 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (1703.749,0.000,179.167) mag= 1713.143921
  WishDir    = (0.993,0.000,0.119) mag= 1.000000
  Accel      = 1803.724791
  WishSpeed  = 20.400000
  dt         = 0.008781
  Dot(Vel,Wish) = 1712.974609
  addSpeed = -1692.574609
  accelSpeed(x10) = 3230.948261
  expectedAdd = 0.000000
  RETURN     = (1793.859,0.000,189.926)
  DELTA      = (90.110,0.000,10.759) mag= 90.750137
  CameraLook = (0.993,0.000,0.119) angle= 0.000000
  CameraRight= (-0.119,0.000,0.993) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.993,0.000,0.119) angle= 0.000000
  RootRight  = (-0.119,0.000,0.993) dot= 0.000009
  Wish(root basis): Right= 0.000009 Forward= 1.000000
  HumMove    = (0.993,0.000,0.119) angle= 0.000000

ACCEL #16 t=1.1725 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (1723.131,0.000,182.438) mag= 1732.761719
  WishDir    = (0.993,0.000,0.119) mag= 1.000000
  Accel      = 1814.583297
  WishSpeed  = 20.400000
  dt         = 0.007886
  Dot(Vel,Wish) = 1732.607178
  addSpeed = -1712.207178
  accelSpeed(x10) = 2919.061047
  expectedAdd = 0.000000
  RETURN     = (1804.529,0.000,192.157)
  DELTA      = (81.398,0.000,9.719) mag= 81.976097
  CameraLook = (0.993,0.000,0.119) angle= 0.000000
  CameraRight= (-0.119,0.000,0.993) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.993,0.000,0.119) angle= 0.000000
  RootRight  = (-0.119,0.000,0.993) dot= 0.000009
  Wish(root basis): Right= 0.000009 Forward= 1.000000
  HumMove    = (0.993,0.000,0.119) angle= 0.000000

ACCEL #17 t=1.1811 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (1729.162,0.000,184.131) mag= 1738.937866
  WishDir    = (0.993,0.000,0.120) mag= 1.000000
  Accel      = 1826.085384
  WishSpeed  = 20.400000
  dt         = 0.008353
  Dot(Vel,Wish) = 1738.769775
  addSpeed = -1718.369775
  accelSpeed(x10) = 3111.702473
  expectedAdd = 0.000000
  RETURN     = (1815.850,0.000,194.583)
  DELTA      = (86.688,0.000,10.452) mag= 87.315544
  CameraLook = (0.993,0.000,0.120) angle= 0.000000
  CameraRight= (-0.120,0.000,0.993) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.993,0.000,0.119) angle= 0.059347
  RootRight  = (-0.119,0.000,0.993) dot= 0.001162
  Wish(root basis): Right= 0.001162 Forward= 0.999999
  HumMove    = (0.993,0.000,0.119) angle= 0.059347

ACCEL #18 t=1.1903 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (2515.706,0.000,269.578) mag= 2530.108398
  WishDir    = (0.600,0.000,0.800) mag= 1.000000
  Accel      = 1838.283130
  WishSpeed  = 20.400000
  dt         = 0.008858
  Dot(Vel,Wish) = 1724.437988
  addSpeed = -1704.037988
  accelSpeed(x10) = 3321.883215
  expectedAdd = 0.000000
  RETURN     = (2583.981,0.000,360.678)
  DELTA      = (68.275,0.000,91.100) mag= 113.845123
  CameraLook = (0.992,0.000,0.124) angle= 46.011101
  CameraRight= (-0.124,0.000,0.992) dot= 0.719474
  Wish(cam basis): Right= 0.719474 Forward= 0.694519
  RootLook   = (0.993,0.000,0.120) angle= 46.275958
  RootRight  = (-0.120,0.000,0.993) dot= 0.722677
  Wish(root basis): Right= 0.722677 Forward= 0.691186
  HumMove    = (0.617,0.000,0.787) angle= 1.275335

ACCEL #19 t=1.1981 state=Enum.HumanoidStateType.Jumping callerLine=305
  callerSource = =Opiumware
  Velocity   = (2476.155,0.000,345.628) mag= 2500.160645
  WishDir    = (0.600,0.000,0.800) mag= 1.000000
  Accel      = 1849.775170
  WishSpeed  = 20.400000
  dt         = 0.008346
  Dot(Vel,Wish) = 1761.574219
  addSpeed = -1741.174219
  accelSpeed(x10) = 3149.287516
  expectedAdd = 0.000000
  RETURN     = (2529.051,0.000,416.207)
  DELTA      = (52.896,0.000,70.579) mag= 88.200890
  CameraLook = (0.992,0.000,0.124) angle= 46.011101
  CameraRight= (-0.124,0.000,0.992) dot= 0.719474
  Wish(cam basis): Right= 0.719474 Forward= 0.694519
  RootLook   = (0.992,0.000,0.124) angle= 46.012107
  RootRight  = (-0.124,0.000,0.992) dot= 0.719487
  Wish(root basis): Right= 0.719487 Forward= 0.694506
  HumMove    = (0.614,0.000,0.790) angle= 1.011044

ACCEL #20 t=1.2063 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2529.051,0.000,416.207) mag= 2563.069824
  WishDir    = (-0.128,0.000,0.992) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007786
  Dot(Vel,Wish) = 89.816742
  addSpeed = 92.183258
  accelSpeed(x10) = 2579.089909
  expectedAdd = 92.183258
  RETURN     = (2517.278,0.000,507.635)
  DELTA      = (-11.773,0.000,91.428) mag= 92.183273
  CameraLook = (0.992,0.000,0.128) angle= 90.000000
  CameraRight= (-0.128,0.000,0.992) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.992,0.000,0.124) angle= 90.198358
  RootRight  = (-0.124,0.000,0.992) dot= 0.999994
  Wish(root basis): Right= 0.999994 Forward= -0.003462
  HumMove    = (0.614,0.000,0.790) angle= 45.198158

AIRCONTROL #1 t=1.2063 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.128,0.000,0.992)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2517.278,0.000,507.635)
  Arg6 = 0.007786
  RETURN = (2517.278,0.000,507.635)
  Arg4 vs CameraRight = -0.127709
  Arg4 vs RootRight   = -0.124274
  Arg4 vs CameraLook  = 0.991812
  Arg4 vs RootLook    = 0.992248
  Arg4 vs HumMove     = 0.613747

ACCEL #21 t=1.2149 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2517.278,0.000,507.635) mag= 2567.953369
  WishDir    = (-0.136,0.000,0.991) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008936
  Dot(Vel,Wish) = 161.323364
  addSpeed = 20.676636
  accelSpeed(x10) = 2959.808881
  expectedAdd = 20.676636
  RETURN     = (2514.472,0.000,528.121)
  DELTA      = (-2.806,0.000,20.485) mag= 20.676653
  CameraLook = (0.991,0.000,0.136) angle= 90.000000
  CameraRight= (-0.136,0.000,0.991) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.992,0.000,0.128) angle= 90.462073
  RootRight  = (-0.128,0.000,0.992) dot= 0.999967
  Wish(root basis): Right= 0.999967 Forward= -0.008065
  HumMove    = (0.611,0.000,0.792) angle= 45.462373

AIRCONTROL #2 t=1.2150 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.136,0.000,0.991)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2514.472,0.000,528.121)
  Arg6 = 0.008936
  RETURN = (2514.472,0.000,528.121)
  Arg4 vs CameraRight = -0.135708
  Arg4 vs RootRight   = -0.127714
  Arg4 vs CameraLook  = 0.990749
  Arg4 vs RootLook    = 0.991811
  Arg4 vs HumMove     = 0.611013

ACCEL #22 t=1.2229 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2514.472,0.000,528.121) mag= 2569.335205
  WishDir    = (-0.157,0.000,0.988) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007765
  Dot(Vel,Wish) = 125.823578
  addSpeed = 56.176422
  accelSpeed(x10) = 2571.981961
  expectedAdd = 56.176422
  RETURN     = (2505.632,0.000,583.597)
  DELTA      = (-8.841,0.000,55.476) mag= 56.176407
  CameraLook = (0.988,0.000,0.157) angle= 90.000000
  CameraRight= (-0.157,0.000,0.988) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.991,0.000,0.136) angle= 91.254854
  RootRight  = (-0.136,0.000,0.991) dot= 0.999760
  Wish(root basis): Right= 0.999760 Forward= -0.021900
  HumMove    = (0.605,0.000,0.797) angle= 46.255001

AIRCONTROL #3 t=1.2229 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.157,0.000,0.988)
  Arg3 = 1619.999903
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2505.632,0.000,583.597)
  Arg6 = 0.007765
  RETURN = (2505.632,0.000,583.597)
  Arg4 vs CameraRight = -0.157375
  Arg4 vs RootRight   = -0.135711
  Arg4 vs CameraLook  = 0.987539
  Arg4 vs RootLook    = 0.990748
  Arg4 vs HumMove     = 0.604605

ACCEL #23 t=1.2308 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2505.632,0.000,583.597) mag= 2572.697998
  WishDir    = (-0.157,0.000,0.988) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008271
  Dot(Vel,Wish) = 182.000000
  addSpeed = 0.000000
  accelSpeed(x10) = 2739.741375
  expectedAdd = 0.000000
  RETURN     = (2505.632,0.000,583.597)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (0.988,0.000,0.157) angle= 90.000000
  CameraRight= (-0.157,0.000,0.988) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.988,0.000,0.157) angle= 89.999727
  RootRight  = (-0.157,0.000,0.988) dot= 1.000000
  Wish(root basis): Right= 1.000000 Forward= 0.000005
  HumMove    = (0.587,0.000,0.810) angle= 44.999996

AIRCONTROL #4 t=1.2309 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.157,0.000,0.988)
  Arg3 = 1619.999903
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2505.632,0.000,583.597)
  Arg6 = 0.008271
  RETURN = (2505.632,0.000,583.597)
  Arg4 vs CameraRight = -0.157375
  Arg4 vs RootRight   = -0.157380
  Arg4 vs CameraLook  = 0.987539
  Arg4 vs RootLook    = 0.987538
  Arg4 vs HumMove     = 0.587014

ACCEL #24 t=1.2397 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2505.632,0.000,583.597) mag= 2572.697998
  WishDir    = (-0.171,0.000,0.985) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008932
  Dot(Vel,Wish) = 146.482117
  addSpeed = 35.517883
  accelSpeed(x10) = 2958.607924
  expectedAdd = 35.517883
  RETURN     = (2499.557,0.000,618.592)
  DELTA      = (-6.074,0.000,34.995) mag= 35.517883
  CameraLook = (0.985,0.000,0.171) angle= 90.000001
  CameraRight= (-0.171,0.000,0.985) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.988,0.000,0.157) angle= 90.792565
  RootRight  = (-0.157,0.000,0.988) dot= 0.999904
  Wish(root basis): Right= 0.999904 Forward= -0.013832
  HumMove    = (0.587,0.000,0.810) angle= 45.792623

AIRCONTROL #5 t=1.2398 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.171,0.000,0.985)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2499.557,0.000,618.592)
  Arg6 = 0.008932
  RETURN = (2499.557,0.000,618.592)
  Arg4 vs CameraRight = -0.171022
  Arg4 vs RootRight   = -0.157377
  Arg4 vs CameraLook  = 0.985267
  Arg4 vs RootLook    = 0.987539
  Arg4 vs HumMove     = 0.587014

ACCEL #25 t=1.2477 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2499.557,0.000,618.592) mag= 2574.964600
  WishDir    = (-0.186,0.000,0.983) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007788
  Dot(Vel,Wish) = 143.486877
  addSpeed = 38.513123
  accelSpeed(x10) = 2579.559124
  expectedAdd = 38.513123
  RETURN     = (2492.403,0.000,656.435)
  DELTA      = (-7.155,0.000,37.843) mag= 38.513153
  CameraLook = (0.983,0.000,0.186) angle= 90.000000
  CameraRight= (-0.186,0.000,0.983) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.985,0.000,0.171) angle= 90.858526
  RootRight  = (-0.171,0.000,0.985) dot= 0.999888
  Wish(root basis): Right= 0.999888 Forward= -0.014984
  HumMove    = (0.576,0.000,0.818) angle= 45.858680

AIRCONTROL #6 t=1.2477 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.186,0.000,0.983)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2492.403,0.000,656.435)
  Arg6 = 0.007788
  RETURN = (2492.403,0.000,656.435)
  Arg4 vs CameraRight = -0.185768
  Arg4 vs RootRight   = -0.171024
  Arg4 vs CameraLook  = 0.982594
  Arg4 vs RootLook    = 0.985267
  Arg4 vs HumMove     = 0.575759

ACCEL #26 t=1.2563 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2492.403,0.000,656.435) mag= 2577.397705
  WishDir    = (-0.208,0.000,0.978) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008759
  Dot(Vel,Wish) = 122.678772
  addSpeed = 59.321228
  accelSpeed(x10) = 2901.179494
  expectedAdd = 59.321228
  RETURN     = (2480.042,0.000,714.454)
  DELTA      = (-12.361,0.000,58.019) mag= 59.321217
  CameraLook = (0.978,0.000,0.208) angle= 89.999999
  CameraRight= (-0.208,0.000,0.978) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.983,0.000,0.186) angle= 91.320865
  RootRight  = (-0.186,0.000,0.983) dot= 0.999734
  Wish(root basis): Right= 0.999734 Forward= -0.023051
  HumMove    = (0.563,0.000,0.826) angle= 46.321047

AIRCONTROL #7 t=1.2563 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.208,0.000,0.978)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2480.042,0.000,714.454)
  Arg6 = 0.008759
  RETURN = (2480.042,0.000,714.454)
  Arg4 vs CameraRight = -0.208372
  Arg4 vs RootRight   = -0.185771
  Arg4 vs CameraLook  = 0.978050
  Arg4 vs RootLook    = 0.982593
  Arg4 vs HumMove     = 0.563441

ACCEL #27 t=1.2645 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2480.042,0.000,714.454) mag= 2580.901611
  WishDir    = (-0.270,0.000,0.963) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007907
  Dot(Vel,Wish) = 18.506104
  addSpeed = 163.493896
  accelSpeed(x10) = 2619.197478
  expectedAdd = 163.493896
  RETURN     = (2435.911,0.000,871.879)
  DELTA      = (-44.131,0.000,157.425) mag= 163.493912
  CameraLook = (0.963,0.000,0.270) angle= 90.000002
  CameraRight= (-0.270,0.000,0.963) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.978,0.000,0.208) angle= 93.632599
  RootRight  = (-0.208,0.000,0.978) dot= 0.997991
  Wish(root basis): Right= 0.997991 Forward= -0.063358
  HumMove    = (0.544,0.000,0.839) angle= 48.632899

AIRCONTROL #8 t=1.2645 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.270,0.000,0.963)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2435.911,0.000,871.879)
  Arg6 = 0.007907
  RETURN = (2435.911,0.000,871.879)
  Arg4 vs CameraRight = -0.269926
  Arg4 vs RootRight   = -0.208377
  Arg4 vs CameraLook  = 0.962881
  Arg4 vs RootLook    = 0.978049
  Arg4 vs HumMove     = 0.544244

ACCEL #28 t=1.2724 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2435.911,0.000,871.879) mag= 2587.244385
  WishDir    = (-0.270,0.000,0.963) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008284
  Dot(Vel,Wish) = 182.000061
  addSpeed = -0.000061
  accelSpeed(x10) = 2743.881637
  expectedAdd = 0.000000
  RETURN     = (2435.911,0.000,871.879)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (0.963,0.000,0.270) angle= 90.000002
  CameraRight= (-0.270,0.000,0.963) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.963,0.000,0.270) angle= 89.999209
  RootRight  = (-0.270,0.000,0.963) dot= 1.000000
  Wish(root basis): Right= 1.000000 Forward= 0.000014
  HumMove    = (0.490,0.000,0.872) angle= 44.999991

AIRCONTROL #9 t=1.2725 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.270,0.000,0.963)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2435.911,0.000,871.879)
  Arg6 = 0.008284
  RETURN = (2435.911,0.000,871.879)
  Arg4 vs CameraRight = -0.269926
  Arg4 vs RootRight   = -0.269939
  Arg4 vs CameraLook  = 0.962881
  Arg4 vs RootLook    = 0.962877
  Arg4 vs HumMove     = 0.489993

ACCEL #29 t=1.2809 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2435.911,0.000,871.879) mag= 2587.244385
  WishDir    = (-0.302,0.000,0.953) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008305
  Dot(Vel,Wish) = 95.631042
  addSpeed = 86.368958
  accelSpeed(x10) = 2750.782587
  expectedAdd = 86.368958
  RETURN     = (2409.831,0.000,954.216)
  DELTA      = (-26.080,0.000,82.337) mag= 86.368965
  CameraLook = (0.953,0.000,0.302) angle= 89.999998
  CameraRight= (-0.302,0.000,0.953) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.963,0.000,0.270) angle= 91.915298
  RootRight  = (-0.270,0.000,0.963) dot= 0.999441
  Wish(root basis): Right= 0.999441 Forward= -0.033422
  HumMove    = (0.490,0.000,0.872) angle= 46.915525

AIRCONTROL #10 t=1.2809 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.302,0.000,0.953)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2409.831,0.000,954.216)
  Arg6 = 0.008305
  RETURN = (2409.831,0.000,954.216)
  Arg4 vs CameraRight = -0.301961
  Arg4 vs RootRight   = -0.269930
  Arg4 vs CameraLook  = 0.953320
  Arg4 vs RootLook    = 0.962880
  Arg4 vs HumMove     = 0.489993

ACCEL #30 t=1.2901 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2409.831,0.000,954.216) mag= 2591.874268
  WishDir    = (-0.325,0.000,0.946) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.009361
  Dot(Vel,Wish) = 119.359375
  addSpeed = 62.640625
  accelSpeed(x10) = 3100.627134
  expectedAdd = 62.640625
  RETURN     = (2389.476,0.000,1013.457)
  DELTA      = (-20.355,0.000,59.241) mag= 62.640610
  CameraLook = (0.946,0.000,0.325) angle= 90.000000
  CameraRight= (-0.325,0.000,0.946) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.953,0.000,0.302) angle= 91.386684
  RootRight  = (-0.302,0.000,0.953) dot= 0.999707
  Wish(root basis): Right= 0.999707 Forward= -0.024200
  HumMove    = (0.461,0.000,0.888) angle= 46.387106

AIRCONTROL #11 t=1.2901 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.325,0.000,0.946)
  Arg3 = 1619.999903
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2389.476,0.000,1013.457)
  Arg6 = 0.009361
  RETURN = (2389.476,0.000,1013.457)
  Arg4 vs CameraRight = -0.324949
  Arg4 vs RootRight   = -0.301968
  Arg4 vs CameraLook  = 0.945731
  Arg4 vs RootLook    = 0.953318
  Arg4 vs HumMove     = 0.460581

ACCEL #31 t=1.2977 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2389.476,0.000,1013.457) mag= 2595.513428
  WishDir    = (-0.336,0.000,0.942) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007373
  Dot(Vel,Wish) = 152.140137
  addSpeed = 29.859863
  accelSpeed(x10) = 2442.246258
  expectedAdd = 29.859863
  RETURN     = (2379.448,0.000,1041.583)
  DELTA      = (-10.028,0.000,28.126) mag= 29.859911
  CameraLook = (0.942,0.000,0.336) angle= 90.000000
  CameraRight= (-0.336,0.000,0.942) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.946,0.000,0.325) angle= 90.660134
  RootRight  = (-0.325,0.000,0.946) dot= 0.999934
  Wish(root basis): Right= 0.999934 Forward= -0.011521
  HumMove    = (0.439,0.000,0.899) angle= 45.660525

AIRCONTROL #12 t=1.2977 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.336,0.000,0.942)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2379.448,0.000,1041.583)
  Arg6 = 0.007373
  RETURN = (2379.448,0.000,1041.583)
  Arg4 vs CameraRight = -0.335830
  Arg4 vs RootRight   = -0.324956
  Arg4 vs CameraLook  = 0.941922
  Arg4 vs RootLook    = 0.945729
  Arg4 vs HumMove     = 0.438959

ACCEL #32 t=1.3064 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2379.448,0.000,1041.583) mag= 2597.434814
  WishDir    = (-0.388,0.000,0.921) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008851
  Dot(Vel,Wish) = 35.421509
  addSpeed = 146.578491
  accelSpeed(x10) = 2931.736174
  expectedAdd = 146.578491
  RETURN     = (2322.506,0.000,1176.649)
  DELTA      = (-56.942,0.000,135.066) mag= 146.578552
  CameraLook = (0.921,0.000,0.388) angle= 90.000000
  CameraRight= (-0.388,0.000,0.921) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.942,0.000,0.336) angle= 93.236345
  RootRight  = (-0.336,0.000,0.942) dot= 0.998405
  Wish(root basis): Right= 0.998405 Forward= -0.056455
  HumMove    = (0.429,0.000,0.904) angle= 48.236589

AIRCONTROL #13 t=1.3064 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.388,0.000,0.921)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2322.506,0.000,1176.649)
  Arg6 = 0.008851
  RETURN = (2322.506,0.000,1176.649)
  Arg4 vs CameraRight = -0.388475
  Arg4 vs RootRight   = -0.335834
  Arg4 vs CameraLook  = 0.921459
  Arg4 vs RootLook    = 0.941921
  Arg4 vs HumMove     = 0.428572

ACCEL #33 t=1.3147 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2322.506,0.000,1176.649) mag= 2603.562256
  WishDir    = (-0.427,0.000,0.904) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008320
  Dot(Vel,Wish) = 71.084534
  addSpeed = 110.915466
  accelSpeed(x10) = 2755.834132
  expectedAdd = 110.915466
  RETURN     = (2275.099,0.000,1276.923)
  DELTA      = (-47.407,0.000,100.274) mag= 110.915543
  CameraLook = (0.904,0.000,0.427) angle= 90.000002
  CameraRight= (-0.427,0.000,0.904) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.921,0.000,0.388) angle= 92.443267
  RootRight  = (-0.388,0.000,0.921) dot= 0.999091
  Wish(root basis): Right= 0.999091 Forward= -0.042630
  HumMove    = (0.377,0.000,0.926) angle= 47.443959

AIRCONTROL #14 t=1.3147 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.427,0.000,0.904)
  Arg3 = 1619.999903
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2275.099,0.000,1276.923)
  Arg6 = 0.008320
  RETURN = (2275.099,0.000,1276.923)
  Arg4 vs CameraRight = -0.427414
  Arg4 vs RootRight   = -0.388486
  Arg4 vs CameraLook  = 0.904056
  Arg4 vs RootLook    = 0.921455
  Arg4 vs HumMove     = 0.376877

ACCEL #34 t=1.3227 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2275.099,0.000,1276.923) mag= 2608.947510
  WishDir    = (-0.468,0.000,0.884) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007835
  Dot(Vel,Wish) = 64.841064
  addSpeed = 117.158936
  accelSpeed(x10) = 2595.375781
  expectedAdd = 117.158936
  RETURN     = (2220.313,0.000,1380.484)
  DELTA      = (-54.785,0.000,103.561) mag= 117.158981
  CameraLook = (0.884,0.000,0.468) angle= 90.000000
  CameraRight= (-0.468,0.000,0.884) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.904,0.000,0.427) angle= 92.575358
  RootRight  = (-0.427,0.000,0.904) dot= 0.998990
  Wish(root basis): Right= 0.998990 Forward= -0.044933
  HumMove    = (0.337,0.000,0.941) angle= 47.576057

AIRCONTROL #15 t=1.3227 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.468,0.000,0.884)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2220.313,0.000,1380.484)
  Arg6 = 0.007835
  RETURN = (2220.313,0.000,1380.484)
  Arg4 vs CameraRight = -0.467616
  Arg4 vs RootRight   = -0.427425
  Arg4 vs CameraLook  = 0.883932
  Arg4 vs RootLook    = 0.904051
  Arg4 vs HumMove     = 0.337036

ACCEL #35 t=1.3314 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2220.313,0.000,1380.484) mag= 2614.483887
  WishDir    = (-0.499,0.000,0.867) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008896
  Dot(Vel,Wish) = 88.693970
  addSpeed = 93.306030
  accelSpeed(x10) = 2946.669620
  expectedAdd = 93.306030
  RETURN     = (2173.763,0.000,1461.348)
  DELTA      = (-46.551,0.000,80.865) mag= 93.306061
  CameraLook = (0.867,0.000,0.499) angle= 90.000002
  CameraRight= (-0.499,0.000,0.867) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.884,0.000,0.468) angle= 92.046922
  RootRight  = (-0.468,0.000,0.884) dot= 0.999362
  Wish(root basis): Right= 0.999362 Forward= -0.035718
  HumMove    = (0.294,0.000,0.956) angle= 47.047633

AIRCONTROL #16 t=1.3315 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.499,0.000,0.867)
  Arg3 = 1619.999903
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2173.763,0.000,1461.348)
  Arg6 = 0.008896
  RETURN = (2173.763,0.000,1461.348)
  Arg4 vs CameraRight = -0.498900
  Arg4 vs RootRight   = -0.467627
  Arg4 vs CameraLook  = 0.866659
  Arg4 vs RootLook    = 0.883926
  Arg4 vs HumMove     = 0.294380

ACCEL #36 t=1.3394 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2173.763,0.000,1461.348) mag= 2619.309570
  WishDir    = (-0.526,0.000,0.851) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007789
  Dot(Vel,Wish) = 100.592041
  addSpeed = 81.407959
  accelSpeed(x10) = 2580.000729
  expectedAdd = 81.407959
  RETURN     = (2130.972,0.000,1530.603)
  DELTA      = (-42.791,0.000,69.255) mag= 81.407928
  CameraLook = (0.851,0.000,0.526) angle= 90.000002
  CameraRight= (-0.526,0.000,0.851) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.867,0.000,0.499) angle= 91.782793
  RootRight  = (-0.499,0.000,0.867) dot= 0.999516
  Wish(root basis): Right= 0.999516 Forward= -0.031111
  HumMove    = (0.260,0.000,0.966) angle= 46.783421

AIRCONTROL #17 t=1.3395 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.526,0.000,0.851)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2130.972,0.000,1530.603)
  Arg6 = 0.007789
  RETURN = (2130.972,0.000,1530.603)
  Arg4 vs CameraRight = -0.525630
  Arg4 vs RootRight   = -0.498910
  Arg4 vs CameraLook  = 0.850713
  Arg4 vs RootLook    = 0.866654
  Arg4 vs HumMove     = 0.260045

ACCEL #37 t=1.3474 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2130.972,0.000,1530.603) mag= 2623.697510
  WishDir    = (-0.566,0.000,0.824) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008275
  Dot(Vel,Wish) = 55.104980
  addSpeed = 126.895020
  accelSpeed(x10) = 2740.955905
  expectedAdd = 126.895020
  RETURN     = (2059.125,0.000,1635.199)
  DELTA      = (-71.847,0.000,104.596) mag= 126.895073
  CameraLook = (0.824,0.000,0.566) angle= 90.000000
  CameraRight= (-0.566,0.000,0.824) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.851,0.000,0.526) angle= 92.773664
  RootRight  = (-0.526,0.000,0.851) dot= 0.998828
  Wish(root basis): Right= 0.998828 Forward= -0.048391
  HumMove    = (0.230,0.000,0.973) angle= 47.774213

AIRCONTROL #18 t=1.3475 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.566,0.000,0.824)
  Arg3 = 1619.999903
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2059.125,0.000,1635.199)
  Arg6 = 0.008275
  RETURN = (2059.125,0.000,1635.199)
  Arg4 vs CameraRight = -0.566189
  Arg4 vs RootRight   = -0.525639
  Arg4 vs CameraLook  = 0.824275
  Arg4 vs RootLook    = 0.850708
  Arg4 vs HumMove     = 0.229868

ACCEL #38 t=1.3563 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2059.125,0.000,1635.199) mag= 2629.424805
  WishDir    = (-0.610,0.000,0.792) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008650
  Dot(Vel,Wish) = 39.672729
  addSpeed = 142.327271
  accelSpeed(x10) = 2865.060409
  expectedAdd = 142.327271
  RETURN     = (1972.306,0.000,1747.980)
  DELTA      = (-86.819,0.000,112.781) mag= 142.327301
  CameraLook = (0.792,0.000,0.610) angle= 90.000000
  CameraRight= (-0.610,0.000,0.792) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.824,0.000,0.566) angle= 93.103764
  RootRight  = (-0.566,0.000,0.824) dot= 0.998533
  Wish(root basis): Right= 0.998533 Forward= -0.054144
  HumMove    = (0.182,0.000,0.983) angle= 48.104483

AIRCONTROL #19 t=1.3563 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.610,0.000,0.792)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1972.306,0.000,1747.980)
  Arg6 = 0.008650
  RETURN = (1972.306,0.000,1747.980)
  Arg4 vs CameraRight = -0.609999
  Arg4 vs RootRight   = -0.566200
  Arg4 vs CameraLook  = 0.792403
  Arg4 vs RootLook    = 0.824268
  Arg4 vs HumMove     = 0.182494

ACCEL #39 t=1.3642 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1972.306,0.000,1747.980) mag= 2635.417236
  WishDir    = (-0.637,0.000,0.771) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008025
  Dot(Vel,Wish) = 90.980225
  addSpeed = 91.019775
  accelSpeed(x10) = 2658.228722
  expectedAdd = 91.019775
  RETURN     = (1914.323,0.000,1818.141)
  DELTA      = (-57.983,0.000,70.161) mag= 91.019730
  CameraLook = (0.771,0.000,0.637) angle= 90.000000
  CameraRight= (-0.637,0.000,0.771) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.792,0.000,0.610) angle= 91.980762
  RootRight  = (-0.610,0.000,0.792) dot= 0.999403
  Wish(root basis): Right= 0.999403 Forward= -0.034564
  HumMove    = (0.129,0.000,0.992) angle= 46.981589

AIRCONTROL #20 t=1.3643 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.637,0.000,0.771)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1914.323,0.000,1818.141)
  Arg6 = 0.008025
  RETURN = (1914.323,0.000,1818.141)
  Arg4 vs CameraRight = -0.637034
  Arg4 vs RootRight   = -0.610010
  Arg4 vs CameraLook  = 0.770836
  Arg4 vs RootLook    = 0.792394
  Arg4 vs HumMove     = 0.128979

ACCEL #40 t=1.3731 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1914.323,0.000,1818.141) mag= 2640.127197
  WishDir    = (-0.662,0.000,0.749) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008905
  Dot(Vel,Wish) = 93.858643
  addSpeed = 88.141357
  accelSpeed(x10) = 2949.595660
  expectedAdd = 88.141357
  RETURN     = (1855.935,0.000,1884.169)
  DELTA      = (-58.389,0.000,66.028) mag= 88.141335
  CameraLook = (0.749,0.000,0.662) angle= 90.000000
  CameraRight= (-0.662,0.000,0.749) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.771,0.000,0.637) angle= 91.914886
  RootRight  = (-0.637,0.000,0.771) dot= 0.999442
  Wish(root basis): Right= 0.999442 Forward= -0.033415
  HumMove    = (0.095,0.000,0.996) angle= 46.915534

AIRCONTROL #21 t=1.3731 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.662,0.000,0.749)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1855.935,0.000,1884.169)
  Arg6 = 0.008905
  RETURN = (1855.935,0.000,1884.169)
  Arg4 vs CameraRight = -0.662444
  Arg4 vs RootRight   = -0.637043
  Arg4 vs CameraLook  = 0.749112
  Arg4 vs RootLook    = 0.770829
  Arg4 vs HumMove     = 0.094612

ACCEL #41 t=1.3808 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1855.935,0.000,1884.169) mag= 2644.728027
  WishDir    = (-0.687,0.000,0.727) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007764
  Dot(Vel,Wish) = 93.704590
  addSpeed = 88.295410
  accelSpeed(x10) = 2571.650796
  expectedAdd = 88.295410
  RETURN     = (1795.266,0.000,1948.320)
  DELTA      = (-60.669,0.000,64.151) mag= 88.295372
  CameraLook = (0.727,0.000,0.687) angle= 90.000003
  CameraRight= (-0.687,0.000,0.727) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.749,0.000,0.662) angle= 91.914939
  RootRight  = (-0.662,0.000,0.749) dot= 0.999442
  Wish(root basis): Right= 0.999442 Forward= -0.033416
  HumMove    = (0.061,0.000,0.998) angle= 46.915534

AIRCONTROL #22 t=1.3809 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.687,0.000,0.727)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1795.266,0.000,1948.320)
  Arg6 = 0.007764
  RETURN = (1795.266,0.000,1948.320)
  Arg4 vs CameraRight = -0.687114
  Arg4 vs RootRight   = -0.662452
  Arg4 vs CameraLook  = 0.726550
  Arg4 vs RootLook    = 0.749105
  Arg4 vs HumMove     = 0.061283

ACCEL #42 t=1.3893 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1795.266,0.000,1948.320) mag= 2649.326172
  WishDir    = (-0.713,0.000,0.701) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008308
  Dot(Vel,Wish) = 84.393677
  addSpeed = 97.606323
  accelSpeed(x10) = 2751.872795
  expectedAdd = 97.606323
  RETURN     = (1725.629,0.000,2016.714)
  DELTA      = (-69.637,0.000,68.394) mag= 97.606354
  CameraLook = (0.701,0.000,0.713) angle= 90.000002
  CameraRight= (-0.713,0.000,0.701) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.727,0.000,0.687) angle= 92.113121
  RootRight  = (-0.687,0.000,0.727) dot= 0.999320
  Wish(root basis): Right= 0.999320 Forward= -0.036873
  HumMove    = (0.028,0.000,1.000) angle= 47.113682

AIRCONTROL #23 t=1.3894 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.713,0.000,0.701)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1725.629,0.000,2016.714)
  Arg6 = 0.008308
  RETURN = (1725.629,0.000,2016.714)
  Arg4 vs CameraRight = -0.713443
  Arg4 vs RootRight   = -0.687121
  Arg4 vs CameraLook  = 0.700713
  Arg4 vs RootLook    = 0.726543
  Arg4 vs HumMove     = 0.027886

ACCEL #43 t=1.3983 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1725.629,0.000,2016.714) mag= 2654.229004
  WishDir    = (-0.740,0.000,0.672) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008991
  Dot(Vel,Wish) = 78.095093
  addSpeed = 103.904907
  accelSpeed(x10) = 2978.123700
  expectedAdd = 103.904907
  RETURN     = (1648.703,0.000,2086.561)
  DELTA      = (-76.926,0.000,69.847) mag= 103.904900
  CameraLook = (0.672,0.000,0.740) angle= 90.000000
  CameraRight= (-0.740,0.000,0.672) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.701,0.000,0.713) angle= 92.245185
  RootRight  = (-0.713,0.000,0.701) dot= 0.999232
  Wish(root basis): Right= 0.999232 Forward= -0.039176
  HumMove    = (-0.009,0.000,1.000) angle= 47.245790

AIRCONTROL #24 t=1.3983 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.740,0.000,0.672)
  Arg3 = 1619.999903
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1648.703,0.000,2086.561)
  Arg6 = 0.008991
  RETURN = (1648.703,0.000,2086.561)
  Arg4 vs CameraRight = -0.740354
  Arg4 vs RootRight   = -0.713450
  Arg4 vs CameraLook  = 0.672218
  Arg4 vs RootLook    = 0.700706
  Arg4 vs HumMove     = -0.009001

ACCEL #44 t=1.4059 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1648.703,0.000,2086.561) mag= 2659.314941
  WishDir    = (-0.773,0.000,0.635) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007677
  Dot(Vel,Wish) = 50.311768
  addSpeed = 131.688232
  accelSpeed(x10) = 2542.929485
  expectedAdd = 131.688232
  RETURN     = (1546.940,0.000,2170.144)
  DELTA      = (-101.763,0.000,83.583) mag= 131.688202
  CameraLook = (0.635,0.000,0.773) angle= 90.000000
  CameraRight= (-0.773,0.000,0.635) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.672,0.000,0.740) angle= 92.839623
  RootRight  = (-0.740,0.000,0.672) dot= 0.998772
  Wish(root basis): Right= 0.998772 Forward= -0.049540
  HumMove    = (-0.048,0.000,0.999) angle= 47.840257

AIRCONTROL #25 t=1.4060 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.773,0.000,0.635)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1546.940,0.000,2170.144)
  Arg6 = 0.007677
  RETURN = (1546.940,0.000,2170.144)
  Arg4 vs CameraRight = -0.772754
  Arg4 vs RootRight   = -0.740361
  Arg4 vs CameraLook  = 0.634706
  Arg4 vs RootLook    = 0.672209
  Arg4 vs HumMove     = -0.048179

ACCEL #45 t=1.4142 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1546.940,0.000,2170.144) mag= 2665.060547
  WishDir    = (-0.807,0.000,0.590) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008335
  Dot(Vel,Wish) = 31.593872
  addSpeed = 150.406128
  accelSpeed(x10) = 2760.995808
  expectedAdd = 150.406128
  RETURN     = (1425.509,0.000,2258.893)
  DELTA      = (-121.431,0.000,88.749) mag= 150.406082
  CameraLook = (0.590,0.000,0.807) angle= 90.000000
  CameraRight= (-0.807,0.000,0.590) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.635,0.000,0.773) angle= 93.235838
  RootRight  = (-0.773,0.000,0.635) dot= 0.998406
  Wish(root basis): Right= 0.998406 Forward= -0.056446
  HumMove    = (-0.098,0.000,0.995) angle= 48.236594

AIRCONTROL #26 t=1.4142 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.807,0.000,0.590)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1425.509,0.000,2258.893)
  Arg6 = 0.008335
  RETURN = (1425.509,0.000,2258.893)
  Arg4 vs CameraRight = -0.807356
  Arg4 vs RootRight   = -0.772762
  Arg4 vs CameraLook  = 0.590065
  Arg4 vs RootLook    = 0.634696
  Arg4 vs HumMove     = -0.097614

ACCEL #46 t=1.4232 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1425.509,0.000,2258.893) mag= 2671.081055
  WishDir    = (-0.829,0.000,0.559) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008828
  Dot(Vel,Wish) = 80.510864
  addSpeed = 101.489136
  accelSpeed(x10) = 2924.297215
  expectedAdd = 101.489136
  RETURN     = (1341.353,0.000,2315.618)
  DELTA      = (-84.156,0.000,56.725) mag= 101.489105
  CameraLook = (0.559,0.000,0.829) angle= 90.000000
  CameraRight= (-0.829,0.000,0.559) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.590,0.000,0.807) angle= 92.178859
  RootRight  = (-0.807,0.000,0.590) dot= 0.999277
  Wish(root basis): Right= 0.999277 Forward= -0.038019
  HumMove    = (-0.154,0.000,0.988) angle= 47.179748

AIRCONTROL #27 t=1.4232 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.829,0.000,0.559)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1341.353,0.000,2315.618)
  Arg6 = 0.008828
  RETURN = (1341.353,0.000,2315.618)
  Arg4 vs CameraRight = -0.829215
  Arg4 vs RootRight   = -0.807365
  Arg4 vs CameraLook  = 0.558930
  Arg4 vs RootLook    = 0.590052
  Arg4 vs HumMove     = -0.153648

ACCEL #47 t=1.4316 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1341.353,0.000,2315.618) mag= 2676.063477
  WishDir    = (-0.847,0.000,0.532) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008486
  Dot(Vel,Wish) = 95.738159
  addSpeed = 86.261841
  accelSpeed(x10) = 2810.861266
  expectedAdd = 86.261841
  RETURN     = (1268.304,0.000,2361.499)
  DELTA      = (-73.048,0.000,45.881) mag= 86.261757
  CameraLook = (0.532,0.000,0.847) angle= 90.000002
  CameraRight= (-0.847,0.000,0.532) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.559,0.000,0.829) angle= 91.848753
  RootRight  = (-0.829,0.000,0.559) dot= 0.999479
  Wish(root basis): Right= 0.999479 Forward= -0.032261
  HumMove    = (-0.191,0.000,0.982) angle= 46.849478

AIRCONTROL #28 t=1.4317 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.847,0.000,0.532)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1268.304,0.000,2361.499)
  Arg6 = 0.008486
  RETURN = (1268.304,0.000,2361.499)
  Arg4 vs CameraRight = -0.846822
  Arg4 vs RootRight   = -0.829222
  Arg4 vs CameraLook  = 0.531877
  Arg4 vs RootLook    = 0.558920
  Arg4 vs HumMove     = -0.191120

ACCEL #48 t=1.4392 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1268.304,0.000,2361.499) mag= 2680.536133
  WishDir    = (-0.869,0.000,0.495) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007750
  Dot(Vel,Wish) = 67.794678
  addSpeed = 114.205322
  accelSpeed(x10) = 2567.248008
  expectedAdd = 114.205322
  RETURN     = (1169.091,0.000,2418.063)
  DELTA      = (-99.214,0.000,56.564) mag= 114.205299
  CameraLook = (0.495,0.000,0.869) angle= 89.999998
  CameraRight= (-0.869,0.000,0.495) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.532,0.000,0.847) angle= 92.443363
  RootRight  = (-0.847,0.000,0.532) dot= 0.999091
  Wish(root basis): Right= 0.999091 Forward= -0.042632
  HumMove    = (-0.223,0.000,0.975) angle= 47.443950

AIRCONTROL #29 t=1.4392 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.869,0.000,0.495)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1169.091,0.000,2418.063)
  Arg6 = 0.007750
  RETURN = (1169.091,0.000,2418.063)
  Arg4 vs CameraRight = -0.868732
  Arg4 vs RootRight   = -0.846827
  Arg4 vs CameraLook  = 0.495283
  Arg4 vs RootLook    = 0.531868
  Arg4 vs HumMove     = -0.222699

ACCEL #49 t=1.4474 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1169.091,0.000,2418.063) mag= 2685.852051
  WishDir    = (-0.886,0.000,0.463) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008237
  Dot(Vel,Wish) = 83.042480
  addSpeed = 98.957520
  accelSpeed(x10) = 2728.327198
  expectedAdd = 98.957520
  RETURN     = (1081.374,0.000,2463.871)
  DELTA      = (-87.717,0.000,45.808) mag= 98.957550
  CameraLook = (0.463,0.000,0.886) angle= 90.000000
  CameraRight= (-0.886,0.000,0.463) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.495,0.000,0.869) angle= 92.113017
  RootRight  = (-0.869,0.000,0.495) dot= 0.999320
  Wish(root basis): Right= 0.999320 Forward= -0.036871
  HumMove    = (-0.264,0.000,0.965) angle= 47.113700

AIRCONTROL #30 t=1.4474 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.886,0.000,0.463)
  Arg3 = 1619.999903
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1081.374,0.000,2463.871)
  Arg6 = 0.008237
  RETURN = (1081.374,0.000,2463.871)
  Arg4 vs CameraRight = -0.886408
  Arg4 vs RootRight   = -0.868738
  Arg4 vs CameraLook  = 0.462905
  Arg4 vs RootLook    = 0.495273
  Arg4 vs HumMove     = -0.264068

ACCEL #50 t=1.4556 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1081.374,0.000,2463.871) mag= 2690.730225
  WishDir    = (-0.904,0.000,0.428) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008344
  Dot(Vel,Wish) = 76.661560
  addSpeed = 105.338440
  accelSpeed(x10) = 2763.783644
  expectedAdd = 105.338440
  RETURN     = (986.162,0.000,2508.936)
  DELTA      = (-95.212,0.000,45.065) mag= 105.338402
  CameraLook = (0.428,0.000,0.904) angle= 89.999998
  CameraRight= (-0.904,0.000,0.428) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.463,0.000,0.886) angle= 92.245145
  RootRight  = (-0.886,0.000,0.463) dot= 0.999232
  Wish(root basis): Right= 0.999232 Forward= -0.039175
  HumMove    = (-0.299,0.000,0.954) angle= 47.245790

AIRCONTROL #31 t=1.4557 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.904,0.000,0.428)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (986.162,0.000,2508.936)
  Arg6 = 0.008344
  RETURN = (986.162,0.000,2508.936)
  Arg4 vs CameraRight = -0.903867
  Arg4 vs RootRight   = -0.886413
  Arg4 vs CameraLook  = 0.427814
  Arg4 vs RootLook    = 0.462895
  Arg4 vs HumMove     = -0.299462

ACCEL #51 t=1.4645 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (986.162,0.000,2508.936) mag= 2695.788330
  WishDir    = (-0.921,0.000,0.389) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008346
  Dot(Vel,Wish) = 67.142761
  addSpeed = 114.857239
  accelSpeed(x10) = 2764.667163
  expectedAdd = 114.857239
  RETURN     = (880.345,0.000,2553.602)
  DELTA      = (-105.817,0.000,44.666) mag= 114.857262
  CameraLook = (0.389,0.000,0.921) angle= 89.999998
  CameraRight= (-0.921,0.000,0.389) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.428,0.000,0.904) angle= 92.443305
  RootRight  = (-0.904,0.000,0.428) dot= 0.999091
  Wish(root basis): Right= 0.999091 Forward= -0.042631
  HumMove    = (-0.337,0.000,0.942) angle= 47.443950

AIRCONTROL #32 t=1.4645 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.921,0.000,0.389)
  Arg3 = 1619.999903
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (880.345,0.000,2553.602)
  Arg6 = 0.008346
  RETURN = (880.345,0.000,2553.602)
  Arg4 vs CameraRight = -0.921287
  Arg4 vs RootRight   = -0.903871
  Arg4 vs CameraLook  = 0.388882
  Arg4 vs RootLook    = 0.427804
  Arg4 vs HumMove     = -0.336620

ACCEL #52 t=1.4730 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (880.345,0.000,2553.602) mag= 2701.090820
  WishDir    = (-0.934,0.000,0.357) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008829
  Dot(Vel,Wish) = 88.704163
  addSpeed = 93.295837
  accelSpeed(x10) = 2924.462875
  expectedAdd = 93.295837
  RETURN     = (793.190,0.000,2586.889)
  DELTA      = (-87.155,0.000,33.287) mag= 93.295830
  CameraLook = (0.357,0.000,0.934) angle= 90.000002
  CameraRight= (-0.934,0.000,0.357) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.389,0.000,0.921) angle= 91.980881
  RootRight  = (-0.921,0.000,0.389) dot= 0.999402
  Wish(root basis): Right= 0.999402 Forward= -0.034566
  HumMove    = (-0.376,0.000,0.926) angle= 46.981580

AIRCONTROL #33 t=1.4730 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.934,0.000,0.357)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (793.190,0.000,2586.889)
  Arg6 = 0.008829
  RETURN = (793.190,0.000,2586.889)
  Arg4 vs CameraRight = -0.934183
  Arg4 vs RootRight   = -0.921292
  Arg4 vs CameraLook  = 0.356793
  Arg4 vs RootLook    = 0.388871
  Arg4 vs HumMove     = -0.376467

ACCEL #53 t=1.4809 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (793.190,0.000,2586.889) mag= 2705.761963
  WishDir    = (-0.945,0.000,0.326) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007838
  Dot(Vel,Wish) = 94.777527
  addSpeed = 87.222473
  accelSpeed(x10) = 2596.217654
  expectedAdd = 87.222473
  RETURN     = (710.746,0.000,2615.364)
  DELTA      = (-82.444,0.000,28.474) mag= 87.222458
  CameraLook = (0.326,0.000,0.945) angle= 90.000000
  CameraRight= (-0.945,0.000,0.326) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.357,0.000,0.934) angle= 91.848857
  RootRight  = (-0.934,0.000,0.357) dot= 0.999479
  Wish(root basis): Right= 0.999479 Forward= -0.032263
  HumMove    = (-0.408,0.000,0.913) angle= 46.849474

AIRCONTROL #34 t=1.4809 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.945,0.000,0.326)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (710.746,0.000,2615.364)
  Arg6 = 0.007838
  RETURN = (710.746,0.000,2615.364)
  Arg4 vs CameraRight = -0.945212
  Arg4 vs RootRight   = -0.934187
  Arg4 vs CameraLook  = 0.326458
  Arg4 vs RootLook    = 0.356783
  Arg4 vs HumMove     = -0.408276

ACCEL #54 t=1.4894 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (710.746,0.000,2615.364) mag= 2710.218994
  WishDir    = (-0.955,0.000,0.297) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008370
  Dot(Vel,Wish) = 97.755615
  addSpeed = 84.244385
  accelSpeed(x10) = 2772.464897
  expectedAdd = 84.244385
  RETURN     = (630.300,0.000,2640.375)
  DELTA      = (-80.446,0.000,25.011) mag= 84.244370
  CameraLook = (0.297,0.000,0.955) angle= 90.000000
  CameraRight= (-0.955,0.000,0.297) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.326,0.000,0.945) angle= 91.782882
  RootRight  = (-0.945,0.000,0.326) dot= 0.999516
  Wish(root basis): Right= 0.999516 Forward= -0.031112
  HumMove    = (-0.438,0.000,0.899) angle= 46.783426

AIRCONTROL #35 t=1.4894 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.955,0.000,0.297)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (630.300,0.000,2640.375)
  Arg6 = 0.008370
  RETURN = (630.300,0.000,2640.375)
  Arg4 vs CameraRight = -0.954914
  Arg4 vs RootRight   = -0.945215
  Arg4 vs CameraLook  = 0.296883
  Arg4 vs RootLook    = 0.326449
  Arg4 vs HumMove     = -0.437525

ACCEL #55 t=1.4976 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (630.300,0.000,2640.375) mag= 2714.563477
  WishDir    = (-0.967,0.000,0.256) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008289
  Dot(Vel,Wish) = 66.340271
  addSpeed = 115.659729
  accelSpeed(x10) = 2745.786262
  expectedAdd = 115.659729
  RETURN     = (518.491,0.000,2669.971)
  DELTA      = (-111.809,0.000,29.597) mag= 115.659760
  CameraLook = (0.256,0.000,0.967) angle= 90.000000
  CameraRight= (-0.967,0.000,0.256) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.297,0.000,0.955) angle= 92.443414
  RootRight  = (-0.955,0.000,0.297) dot= 0.999091
  Wish(root basis): Right= 0.999091 Forward= -0.042633
  HumMove    = (-0.465,0.000,0.885) angle= 47.443950

AIRCONTROL #36 t=1.4976 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.967,0.000,0.256)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (518.491,0.000,2669.971)
  Arg6 = 0.008289
  RETURN = (518.491,0.000,2669.971)
  Arg4 vs CameraRight = -0.966705
  Arg4 vs RootRight   = -0.954917
  Arg4 vs CameraLook  = 0.255893
  Arg4 vs RootLook    = 0.296874
  Arg4 vs HumMove     = -0.465298

ACCEL #56 t=1.5059 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (518.491,0.000,2669.971) mag= 2719.849121
  WishDir    = (-0.977,0.000,0.211) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008332
  Dot(Vel,Wish) = 56.710297
  addSpeed = 125.289703
  accelSpeed(x10) = 2759.836498
  expectedAdd = 125.289703
  RETURN     = (396.024,0.000,2696.415)
  DELTA      = (-122.467,0.000,26.444) mag= 125.289726
  CameraLook = (0.211,0.000,0.977) angle= 90.000000
  CameraRight= (-0.977,0.000,0.211) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.256,0.000,0.967) angle= 92.641438
  RootRight  = (-0.967,0.000,0.256) dot= 0.998937
  Wish(root basis): Right= 0.998937 Forward= -0.046085
  HumMove    = (-0.503,0.000,0.865) angle= 47.642102

AIRCONTROL #37 t=1.5059 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.977,0.000,0.211)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (396.024,0.000,2696.415)
  Arg6 = 0.008332
  RETURN = (396.024,0.000,2696.415)
  Arg4 vs CameraRight = -0.977473
  Arg4 vs RootRight   = -0.966708
  Arg4 vs CameraLook  = 0.211059
  Arg4 vs RootLook    = 0.255882
  Arg4 vs HumMove     = -0.502620

ACCEL #57 t=1.5147 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (396.024,0.000,2696.415) mag= 2725.341797
  WishDir    = (-0.983,0.000,0.185) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008962
  Dot(Vel,Wish) = 109.842682
  addSpeed = 72.157318
  accelSpeed(x10) = 2968.421032
  expectedAdd = 72.157318
  RETURN     = (325.113,0.000,2709.769)
  DELTA      = (-70.911,0.000,13.354) mag= 72.157341
  CameraLook = (0.185,0.000,0.983) angle= 89.999999
  CameraRight= (-0.983,0.000,0.185) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.211,0.000,0.977) angle= 91.518460
  RootRight  = (-0.977,0.000,0.211) dot= 0.999649
  Wish(root basis): Right= 0.999649 Forward= -0.026499
  HumMove    = (-0.542,0.000,0.840) angle= 46.519212

AIRCONTROL #38 t=1.5148 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.983,0.000,0.185)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (325.113,0.000,2709.769)
  Arg6 = 0.008962
  RETURN = (325.113,0.000,2709.769)
  Arg4 vs CameraRight = -0.982725
  Arg4 vs RootRight   = -0.977476
  Arg4 vs CameraLook  = 0.185070
  Arg4 vs RootLook    = 0.211046
  Arg4 vs HumMove     = -0.541937

ACCEL #58 t=1.5225 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (325.113,0.000,2709.769) mag= 2729.202637
  WishDir    = (-0.987,0.000,0.160) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007719
  Dot(Vel,Wish) = 112.883575
  addSpeed = 69.116425
  accelSpeed(x10) = 2556.676011
  expectedAdd = 69.116425
  RETURN     = (256.888,0.000,2720.834)
  DELTA      = (-68.225,0.000,11.065) mag= 69.116417
  CameraLook = (0.160,0.000,0.987) angle= 90.000000
  CameraRight= (-0.987,0.000,0.160) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.185,0.000,0.983) angle= 91.452615
  RootRight  = (-0.983,0.000,0.185) dot= 0.999679
  Wish(root basis): Right= 0.999679 Forward= -0.025350
  HumMove    = (-0.564,0.000,0.826) angle= 46.453158

AIRCONTROL #39 t=1.5226 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.987,0.000,0.160)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (256.888,0.000,2720.834)
  Arg6 = 0.007719
  RETURN = (256.888,0.000,2720.834)
  Arg4 vs CameraRight = -0.987103
  Arg4 vs RootRight   = -0.982727
  Arg4 vs CameraLook  = 0.160089
  Arg4 vs RootLook    = 0.185061
  Arg4 vs HumMove     = -0.564028

ACCEL #59 t=1.5309 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (256.888,0.000,2720.834) mag= 2732.933838
  WishDir    = (-0.991,0.000,0.132) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008317
  Dot(Vel,Wish) = 103.344299
  addSpeed = 78.655701
  accelSpeed(x10) = 2754.757497
  expectedAdd = 78.655701
  RETURN     = (178.916,0.000,2731.183)
  DELTA      = (-77.972,0.000,10.349) mag= 78.655708
  CameraLook = (0.132,0.000,0.991) angle= 90.000000
  CameraRight= (-0.991,0.000,0.132) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.160,0.000,0.987) angle= 91.650866
  RootRight  = (-0.987,0.000,0.160) dot= 0.999585
  Wish(root basis): Right= 0.999585 Forward= -0.028809
  HumMove    = (-0.585,0.000,0.811) angle= 46.651317

AIRCONTROL #40 t=1.5309 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.991,0.000,0.132)
  Arg3 = 1619.999903
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (178.916,0.000,2731.183)
  Arg6 = 0.008317
  RETURN = (178.916,0.000,2731.183)
  Arg4 vs CameraRight = -0.991306
  Arg4 vs RootRight   = -0.987104
  Arg4 vs CameraLook  = 0.131577
  Arg4 vs RootLook    = 0.160081
  Arg4 vs HumMove     = -0.584787

ACCEL #60 t=1.5393 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (178.916,0.000,2731.183) mag= 2737.037109
  WishDir    = (-0.994,0.000,0.105) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008329
  Dot(Vel,Wish) = 109.531921
  addSpeed = 72.468079
  accelSpeed(x10) = 2758.939405
  expectedAdd = 72.468079
  RETURN     = (106.851,0.000,2738.810)
  DELTA      = (-72.066,0.000,7.627) mag= 72.468079
  CameraLook = (0.105,0.000,0.994) angle= 90.000000
  CameraRight= (-0.994,0.000,0.105) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.132,0.000,0.991) angle= 91.518736
  RootRight  = (-0.991,0.000,0.132) dot= 0.999649
  Wish(root basis): Right= 0.999649 Forward= -0.026504
  HumMove    = (-0.608,0.000,0.794) angle= 46.519203

AIRCONTROL #41 t=1.5393 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.994,0.000,0.105)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (106.851,0.000,2738.810)
  Arg6 = 0.008329
  RETURN = (106.851,0.000,2738.810)
  Arg4 vs CameraRight = -0.994446
  Arg4 vs RootRight   = -0.991307
  Arg4 vs CameraLook  = 0.105249
  Arg4 vs RootLook    = 0.131569
  Arg4 vs HumMove     = -0.607920

ACCEL #61 t=1.5475 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (106.851,0.000,2738.810) mag= 2740.893799
  WishDir    = (-0.997,0.000,0.082) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008327
  Dot(Vel,Wish) = 118.900604
  addSpeed = 63.099396
  accelSpeed(x10) = 2758.331986
  expectedAdd = 63.099396
  RETURN     = (43.965,0.000,2744.003)
  DELTA      = (-62.885,0.000,5.193) mag= 63.099388
  CameraLook = (0.082,0.000,0.997) angle= 90.000000
  CameraRight= (-0.997,0.000,0.082) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.105,0.000,0.994) angle= 91.320608
  RootRight  = (-0.994,0.000,0.105) dot= 0.999735
  Wish(root basis): Right= 0.999735 Forward= -0.023047
  HumMove    = (-0.629,0.000,0.778) angle= 46.321052

AIRCONTROL #42 t=1.5476 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.997,0.000,0.082)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (43.965,0.000,2744.003)
  Arg6 = 0.008327
  RETURN = (43.965,0.000,2744.003)
  Arg4 vs CameraRight = -0.996608
  Arg4 vs RootRight   = -0.994447
  Arg4 vs CameraLook  = 0.082294
  Arg4 vs RootLook    = 0.105241
  Arg4 vs HumMove     = -0.628757

ACCEL #62 t=1.5558 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (43.965,0.000,2744.003) mag= 2744.355225
  WishDir    = (-0.998,0.000,0.059) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008334
  Dot(Vel,Wish) = 118.820602
  addSpeed = 63.179398
  accelSpeed(x10) = 2760.512711
  expectedAdd = 63.179398
  RETURN     = (-19.103,0.000,2747.749)
  DELTA      = (-63.068,0.000,3.746) mag= 63.179405
  CameraLook = (0.059,0.000,0.998) angle= 90.000000
  CameraRight= (-0.998,0.000,0.059) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.082,0.000,0.997) angle= 91.320654
  RootRight  = (-0.997,0.000,0.082) dot= 0.999734
  Wish(root basis): Right= 0.999734 Forward= -0.023048
  HumMove    = (-0.647,0.000,0.763) angle= 46.321052

AIRCONTROL #43 t=1.5558 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.998,0.000,0.059)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-19.103,0.000,2747.749)
  Arg6 = 0.008334
  RETURN = (-19.103,0.000,2747.749)
  Arg4 vs CameraRight = -0.998240
  Arg4 vs RootRight   = -0.996609
  Arg4 vs CameraLook  = 0.059296
  Arg4 vs RootLook    = 0.082287
  Arg4 vs HumMove     = -0.646517

ACCEL #63 t=1.5642 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-19.103,0.000,2747.749) mag= 2747.815674
  WishDir    = (-0.999,0.000,0.037) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008335
  Dot(Vel,Wish) = 121.905197
  addSpeed = 60.094803
  accelSpeed(x10) = 2760.981926
  expectedAdd = 60.094803
  RETURN     = (-79.156,0.000,2749.998)
  DELTA      = (-60.053,0.000,2.249) mag= 60.094795
  CameraLook = (0.037,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,0.037) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.059,0.000,0.998) angle= 91.254609
  RootRight  = (-0.998,0.000,0.059) dot= 0.999760
  Wish(root basis): Right= 0.999760 Forward= -0.021895
  HumMove    = (-0.664,0.000,0.748) angle= 46.255011

AIRCONTROL #44 t=1.5643 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.999,0.000,0.037)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-79.156,0.000,2749.998)
  Arg6 = 0.008335
  RETURN = (-79.156,0.000,2749.998)
  Arg4 vs CameraRight = -0.999300
  Arg4 vs RootRight   = -0.998241
  Arg4 vs CameraLook  = 0.037418
  Arg4 vs RootLook    = 0.059289
  Arg4 vs HumMove     = -0.663934

ACCEL #64 t=1.5724 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-79.156,0.000,2749.998) mag= 2751.136719
  WishDir    = (-1.000,0.000,0.019) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008317
  Dot(Vel,Wish) = 131.337006
  addSpeed = 50.662994
  accelSpeed(x10) = 2754.854055
  expectedAdd = 50.662994
  RETURN     = (-129.810,0.000,2750.959)
  DELTA      = (-50.654,0.000,0.962) mag= 50.662998
  CameraLook = (0.019,0.000,1.000) angle= 90.000000
  CameraRight= (-1.000,0.000,0.019) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.037,0.000,0.999) angle= 91.056478
  RootRight  = (-0.999,0.000,0.037) dot= 0.999830
  Wish(root basis): Right= 0.999830 Forward= -0.018438
  HumMove    = (-0.680,0.000,0.733) angle= 46.056846

AIRCONTROL #45 t=1.5725 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-1.000,0.000,0.019)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-129.810,0.000,2750.959)
  Arg6 = 0.008317
  RETURN = (-129.810,0.000,2750.959)
  Arg4 vs CameraRight = -0.999820
  Arg4 vs RootRight   = -0.999300
  Arg4 vs CameraLook  = 0.018980
  Arg4 vs RootLook    = 0.037412
  Arg4 vs HumMove     = -0.680153

ACCEL #65 t=1.5809 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-129.810,0.000,2750.959) mag= 2754.020508
  WishDir    = (-1.000,0.000,0.001) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008365
  Dot(Vel,Wish) = 131.283707
  addSpeed = 50.716293
  accelSpeed(x10) = 2770.725932
  expectedAdd = 50.716293
  RETURN     = (-180.526,0.000,2750.987)
  DELTA      = (-50.716,0.000,0.027) mag= 50.716286
  CameraLook = (0.001,0.000,1.000) angle= 90.000000
  CameraRight= (-1.000,0.000,0.001) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.019,0.000,1.000) angle= 91.056525
  RootRight  = (-1.000,0.000,0.019) dot= 0.999830
  Wish(root basis): Right= 0.999830 Forward= -0.018439
  HumMove    = (-0.694,0.000,0.720) angle= 46.056846

AIRCONTROL #46 t=1.5810 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-1.000,0.000,0.001)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-180.526,0.000,2750.987)
  Arg6 = 0.008365
  RETURN = (-180.526,0.000,2750.987)
  Arg4 vs CameraRight = -1.000000
  Arg4 vs RootRight   = -0.999820
  Arg4 vs CameraLook  = 0.000536
  Arg4 vs RootLook    = 0.018975
  Arg4 vs HumMove     = -0.693558

AIRCONTROL #47 t=1.5893 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.000,0.000,0.000)
  Arg3 = 0.000000
  Arg4 = (0.000,0.000,-0.000)
  Arg5 = (-180.526,0.000,2750.987)
  Arg6 = 0.008336
  RETURN = (-180.526,0.000,2750.987)
  Arg4 vs CameraRight = 0.000000
  Arg4 vs RootRight   = 0.000000
  Arg4 vs CameraLook  = 0.000000
  Arg4 vs RootLook    = 0.000000
  Arg4 vs HumMove     = 0.000000

ACCEL #66 t=1.5981 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-180.526,0.000,2750.987) mag= 2756.903320
  WishDir    = (0.999,0.000,0.037) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008325
  Dot(Vel,Wish) = -77.239906
  addSpeed = 259.239906
  accelSpeed(x10) = 2757.573097
  expectedAdd = 259.239906
  RETURN     = (78.532,0.000,2760.708)
  DELTA      = (259.058,0.000,9.721) mag= 259.239899
  CameraLook = (-0.037,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,-0.037) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.031,0.000,1.000) angle= 89.603746
  RootRight  = (-1.000,0.000,-0.031) dot= -0.999976
  Wish(root basis): Right= -0.999976 Forward= 0.006916
  HumMove    = (0.685,0.000,0.728) angle= 44.603690

AIRCONTROL #48 t=1.5983 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.999,0.000,0.037)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (78.532,0.000,2760.708)
  Arg6 = 0.008325
  RETURN = (78.532,0.000,2760.708)
  Arg4 vs CameraRight = 0.999297
  Arg4 vs RootRight   = 0.999532
  Arg4 vs CameraLook  = 0.037499
  Arg4 vs RootLook    = 0.030587
  Arg4 vs HumMove     = -0.685148

ACCEL #67 t=1.6056 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (78.532,0.000,2760.708) mag= 2761.824463
  WishDir    = (0.999,0.000,0.037) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008349
  Dot(Vel,Wish) = 181.999985
  addSpeed = 0.000015
  accelSpeed(x10) = 2765.481271
  expectedAdd = 0.000015
  RETURN     = (78.532,0.000,2760.708)
  DELTA      = (0.000,0.000,0.000) mag= 0.000015
  CameraLook = (-0.037,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,-0.037) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.037,0.000,0.999) angle= 89.998803
  RootRight  = (-0.999,0.000,-0.037) dot= -1.000000
  Wish(root basis): Right= -1.000000 Forward= 0.000021
  HumMove    = (0.680,0.000,0.733) angle= 45.000001

AIRCONTROL #49 t=1.6057 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.999,0.000,0.037)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (78.532,0.000,2760.708)
  Arg6 = 0.008349
  RETURN = (78.532,0.000,2760.708)
  Arg4 vs CameraRight = 0.999297
  Arg4 vs RootRight   = 0.999298
  Arg4 vs CameraLook  = 0.037499
  Arg4 vs RootLook    = 0.037478
  Arg4 vs HumMove     = -0.680094

ACCEL #68 t=1.6146 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (78.532,0.000,2760.708) mag= 2761.824463
  WishDir    = (0.999,0.000,0.042) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008796
  Dot(Vel,Wish) = 194.705811
  addSpeed = -12.705811
  accelSpeed(x10) = 2913.504338
  expectedAdd = 0.000000
  RETURN     = (78.532,0.000,2760.708)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (-0.042,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,-0.042) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.037,0.000,0.999) angle= 89.735291
  RootRight  = (-0.999,0.000,-0.037) dot= -0.999989
  Wish(root basis): Right= -0.999989 Forward= 0.004620
  HumMove    = (0.680,0.000,0.733) angle= 44.735797

AIRCONTROL #50 t=1.6146 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.999,0.000,0.042)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (78.532,0.000,2760.708)
  Arg6 = 0.008796
  RETURN = (78.532,0.000,2760.708)
  Arg4 vs CameraRight = 0.999113
  Arg4 vs RootRight   = 0.999297
  Arg4 vs CameraLook  = 0.042106
  Arg4 vs RootLook    = 0.037490
  Arg4 vs HumMove     = -0.680094

ACCEL #69 t=1.6225 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (78.532,0.000,2760.708) mag= 2761.824463
  WishDir    = (0.999,0.000,0.046) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007874
  Dot(Vel,Wish) = 204.232651
  addSpeed = -22.232651
  accelSpeed(x10) = 2608.308044
  expectedAdd = 0.000000
  RETURN     = (78.532,0.000,2760.708)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (-0.046,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,-0.046) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.042,0.000,0.999) angle= 89.801574
  RootRight  = (-0.999,0.000,-0.042) dot= -0.999994
  Wish(root basis): Right= -0.999994 Forward= 0.003463
  HumMove    = (0.677,0.000,0.736) angle= 44.801839

AIRCONTROL #51 t=1.6225 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.999,0.000,0.046)
  Arg3 = 1619.999903
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (78.532,0.000,2760.708)
  Arg6 = 0.007874
  RETURN = (78.532,0.000,2760.708)
  Arg4 vs CameraRight = 0.998962
  Arg4 vs RootRight   = 0.999113
  Arg4 vs CameraLook  = 0.045562
  Arg4 vs RootLook    = 0.042102
  Arg4 vs HumMove     = -0.676706

ACCEL #70 t=1.6313 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (78.532,0.000,2760.708) mag= 2761.824463
  WishDir    = (0.999,0.000,0.047) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008925
  Dot(Vel,Wish) = 207.407471
  addSpeed = -25.407471
  accelSpeed(x10) = 2956.192746
  expectedAdd = 0.000000
  RETURN     = (78.532,0.000,2760.708)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (-0.047,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,-0.047) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.046,0.000,0.999) angle= 89.933764
  RootRight  = (-0.999,0.000,-0.046) dot= -0.999999
  Wish(root basis): Right= -0.999999 Forward= 0.001156
  HumMove    = (0.674,0.000,0.739) angle= 44.933951

AIRCONTROL #52 t=1.6314 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.999,0.000,0.047)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (78.532,0.000,2760.708)
  Arg6 = 0.008925
  RETURN = (78.532,0.000,2760.708)
  Arg4 vs CameraRight = 0.998908
  Arg4 vs RootRight   = 0.998962
  Arg4 vs CameraLook  = 0.046713
  Arg4 vs RootLook    = 0.045558
  Arg4 vs HumMove     = -0.674156

ACCEL #71 t=1.6394 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (78.532,0.000,2760.708) mag= 2761.824463
  WishDir    = (0.999,0.000,0.047) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008208
  Dot(Vel,Wish) = 207.407471
  addSpeed = -25.407471
  accelSpeed(x10) = 2718.790189
  expectedAdd = 0.000000
  RETURN     = (78.532,0.000,2760.708)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (-0.047,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,-0.047) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.047,0.000,0.999) angle= 89.999839
  RootRight  = (-0.999,0.000,-0.047) dot= -1.000000
  Wish(root basis): Right= -1.000000 Forward= 0.000003
  HumMove    = (0.673,0.000,0.739) angle= 45.000001

AIRCONTROL #53 t=1.6395 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.999,0.000,0.047)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (78.532,0.000,2760.708)
  Arg6 = 0.008208
  RETURN = (78.532,0.000,2760.708)
  Arg4 vs CameraRight = 0.998908
  Arg4 vs RootRight   = 0.998908
  Arg4 vs CameraLook  = 0.046713
  Arg4 vs RootLook    = 0.046710
  Arg4 vs HumMove     = -0.673304

ACCEL #72 t=1.6482 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (78.532,0.000,2760.708) mag= 2761.824463
  WishDir    = (0.999,0.000,0.047) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008528
  Dot(Vel,Wish) = 207.407471
  addSpeed = -25.407471
  accelSpeed(x10) = 2824.980295
  expectedAdd = 0.000000
  RETURN     = (78.532,0.000,2760.708)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (-0.047,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,-0.047) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.047,0.000,0.999) angle= 89.999848
  RootRight  = (-0.999,0.000,-0.047) dot= -1.000000
  Wish(root basis): Right= -1.000000 Forward= 0.000003
  HumMove    = (0.673,0.000,0.739) angle= 45.000001

AIRCONTROL #54 t=1.6482 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.999,0.000,0.047)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (78.532,0.000,2760.708)
  Arg6 = 0.008528
  RETURN = (78.532,0.000,2760.708)
  Arg4 vs CameraRight = 0.998908
  Arg4 vs RootRight   = 0.998908
  Arg4 vs CameraLook  = 0.046713
  Arg4 vs RootLook    = 0.046711
  Arg4 vs HumMove     = -0.673304

ACCEL #73 t=1.6560 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (78.532,0.000,2760.708) mag= 2761.824463
  WishDir    = (0.999,0.000,0.044) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007696
  Dot(Vel,Wish) = 201.056854
  addSpeed = -19.056854
  accelSpeed(x10) = 2549.347184
  expectedAdd = 0.000000
  RETURN     = (78.532,0.000,2760.708)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (-0.044,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,-0.044) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (-0.047,0.000,0.999) angle= 90.131961
  RootRight  = (-0.999,0.000,-0.047) dot= -0.999997
  Wish(root basis): Right= -0.999997 Forward= -0.002303
  HumMove    = (0.673,0.000,0.739) angle= 45.132109

AIRCONTROL #55 t=1.6560 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.999,0.000,0.044)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (78.532,0.000,2760.708)
  Arg6 = 0.007696
  RETURN = (78.532,0.000,2760.708)
  Arg4 vs CameraRight = 0.999013
  Arg4 vs RootRight   = 0.998908
  Arg4 vs CameraLook  = 0.044410
  Arg4 vs RootLook    = 0.046711
  Arg4 vs HumMove     = -0.673304

ACCEL #74 t=1.6642 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (78.532,0.000,2760.708) mag= 2761.824463
  WishDir    = (0.999,0.000,0.037) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008301
  Dot(Vel,Wish) = 181.999359
  addSpeed = 0.000641
  accelSpeed(x10) = 2749.719834
  expectedAdd = 0.000641
  RETURN     = (78.532,0.000,2760.708)
  DELTA      = (0.001,0.000,0.000) mag= 0.000641
  CameraLook = (-0.037,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,-0.037) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.044,0.000,0.999) angle= 90.396167
  RootRight  = (-0.999,0.000,-0.044) dot= -0.999976
  Wish(root basis): Right= -0.999976 Forward= -0.006914
  HumMove    = (0.675,0.000,0.738) angle= 45.396314

AIRCONTROL #56 t=1.6643 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.999,0.000,0.037)
  Arg3 = 1619.999903
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (78.532,0.000,2760.708)
  Arg6 = 0.008301
  RETURN = (78.532,0.000,2760.708)
  Arg4 vs CameraRight = 0.999297
  Arg4 vs RootRight   = 0.999014
  Arg4 vs CameraLook  = 0.037499
  Arg4 vs RootLook    = 0.044407
  Arg4 vs HumMove     = -0.675007

ACCEL #75 t=1.6731 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (78.532,0.000,2760.708) mag= 2761.824463
  WishDir    = (1.000,0.000,0.028) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008928
  Dot(Vel,Wish) = 156.576355
  addSpeed = 25.423645
  accelSpeed(x10) = 2957.421158
  expectedAdd = 25.423645
  RETURN     = (103.946,0.000,2761.427)
  DELTA      = (25.413,0.000,0.719) mag= 25.423645
  CameraLook = (-0.028,0.000,1.000) angle= 90.000000
  CameraRight= (-1.000,0.000,-0.028) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.037,0.000,0.999) angle= 90.528277
  RootRight  = (-0.999,0.000,-0.037) dot= -0.999958
  Wish(root basis): Right= -0.999958 Forward= -0.009220
  HumMove    = (0.680,0.000,0.733) angle= 45.528425

AIRCONTROL #57 t=1.6731 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (1.000,0.000,0.028)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (103.946,0.000,2761.427)
  Arg6 = 0.008928
  RETURN = (103.946,0.000,2761.427)
  Arg4 vs CameraRight = 0.999600
  Arg4 vs RootRight   = 0.999297
  Arg4 vs CameraLook  = 0.028281
  Arg4 vs RootLook    = 0.037496
  Arg4 vs HumMove     = -0.680094

ACCEL #76 t=1.6809 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (103.946,0.000,2761.427) mag= 2763.382324
  WishDir    = (1.000,0.000,0.010) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007796
  Dot(Vel,Wish) = 131.110657
  addSpeed = 50.889343
  accelSpeed(x10) = 2582.236674
  expectedAdd = 50.889343
  RETURN     = (154.833,0.000,2761.927)
  DELTA      = (50.887,0.000,0.501) mag= 50.889343
  CameraLook = (-0.010,0.000,1.000) angle= 90.000000
  CameraRight= (-1.000,0.000,-0.010) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.028,0.000,1.000) angle= 91.056588
  RootRight  = (-1.000,0.000,-0.028) dot= -0.999830
  Wish(root basis): Right= -0.999830 Forward= -0.018440
  HumMove    = (0.687,0.000,0.727) angle= 46.056846

AIRCONTROL #58 t=1.6809 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (1.000,0.000,0.010)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (154.833,0.000,2761.927)
  Arg6 = 0.007796
  RETURN = (154.833,0.000,2761.927)
  Arg4 vs CameraRight = 0.999952
  Arg4 vs RootRight   = 0.999600
  Arg4 vs CameraLook  = 0.009839
  Arg4 vs RootLook    = 0.028276
  Arg4 vs HumMove     = -0.686826

ACCEL #77 t=1.6897 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (154.833,0.000,2761.927) mag= 2766.263916
  WishDir    = (1.000,0.000,-0.007) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008898
  Dot(Vel,Wish) = 134.243011
  addSpeed = 47.756989
  accelSpeed(x10) = 2947.511493
  expectedAdd = 47.756989
  RETURN     = (202.588,0.000,2761.572)
  DELTA      = (47.756,0.000,-0.356) mag= 47.756989
  CameraLook = (0.007,0.000,1.000) angle= 90.000000
  CameraRight= (-1.000,0.000,0.007) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.010,0.000,1.000) angle= 90.990359
  RootRight  = (-1.000,0.000,-0.010) dot= -0.999851
  Wish(root basis): Right= -0.999851 Forward= -0.017284
  HumMove    = (0.700,0.000,0.714) angle= 45.990787

AIRCONTROL #59 t=1.6898 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (1.000,0.000,-0.007)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (202.588,0.000,2761.572)
  Arg6 = 0.008898
  RETURN = (202.588,0.000,2761.572)
  Arg4 vs CameraRight = 0.999972
  Arg4 vs RootRight   = 0.999952
  Arg4 vs CameraLook  = -0.007453
  Arg4 vs RootLook    = 0.009832
  Arg4 vs HumMove     = -0.700115

ACCEL #78 t=1.6976 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (202.588,0.000,2761.572) mag= 2768.992432
  WishDir    = (1.000,0.000,-0.022) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007759
  Dot(Vel,Wish) = 140.571976
  addSpeed = 41.428024
  accelSpeed(x10) = 2570.118828
  expectedAdd = 41.428024
  RETURN     = (244.006,0.000,2760.642)
  DELTA      = (41.418,0.000,-0.930) mag= 41.428036
  CameraLook = (0.022,0.000,1.000) angle= 90.000000
  CameraRight= (-1.000,0.000,0.022) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.007,0.000,1.000) angle= 90.858230
  RootRight  = (-1.000,0.000,0.007) dot= -0.999888
  Wish(root basis): Right= -0.999888 Forward= -0.014978
  HumMove    = (0.712,0.000,0.702) angle= 45.858690

AIRCONTROL #60 t=1.6976 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (1.000,0.000,-0.022)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (244.006,0.000,2760.642)
  Arg6 = 0.007759
  RETURN = (244.006,0.000,2760.642)
  Arg4 vs CameraRight = 0.999748
  Arg4 vs RootRight   = 0.999972
  Arg4 vs CameraLook  = -0.022438
  Arg4 vs RootLook    = -0.007461
  Arg4 vs HumMove     = -0.712357

ACCEL #79 t=1.7059 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (244.006,0.000,2760.642) mag= 2771.404541
  WishDir    = (0.999,0.000,-0.035) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008304
  Dot(Vel,Wish) = 146.917358
  addSpeed = 35.082642
  accelSpeed(x10) = 2750.520369
  expectedAdd = 35.082642
  RETURN     = (279.067,0.000,2759.410)
  DELTA      = (35.061,0.000,-1.232) mag= 35.082642
  CameraLook = (0.035,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,0.035) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.022,0.000,1.000) angle= 90.726137
  RootRight  = (-1.000,0.000,0.022) dot= -0.999920
  Wish(root basis): Right= -0.999920 Forward= -0.012673
  HumMove    = (0.723,0.000,0.691) angle= 45.726578

AIRCONTROL #61 t=1.7059 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.999,0.000,-0.035)
  Arg3 = 1619.999903
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (279.067,0.000,2759.410)
  Arg6 = 0.008304
  RETURN = (279.067,0.000,2759.410)
  Arg4 vs CameraRight = 0.999383
  Arg4 vs RootRight   = 0.999748
  Arg4 vs CameraLook  = -0.035114
  Arg4 vs RootLook    = -0.022446
  Arg4 vs HumMove     = -0.722795

ACCEL #80 t=1.7148 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (279.067,0.000,2759.410) mag= 2773.485352
  WishDir    = (0.999,0.000,-0.045) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008977
  Dot(Vel,Wish) = 153.276398
  addSpeed = 28.723602
  accelSpeed(x10) = 2973.569135
  expectedAdd = 28.723602
  RETURN     = (307.761,0.000,2758.104)
  DELTA      = (28.694,0.000,-1.306) mag= 28.723602
  CameraLook = (0.045,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,0.045) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.035,0.000,0.999) angle= 90.594057
  RootRight  = (-0.999,0.000,0.035) dot= -0.999946
  Wish(root basis): Right= -0.999946 Forward= -0.010368
  HumMove    = (0.732,0.000,0.682) angle= 45.594474

AIRCONTROL #62 t=1.7149 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.999,0.000,-0.045)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (307.761,0.000,2758.104)
  Arg6 = 0.008977
  RETURN = (307.761,0.000,2758.104)
  Arg4 vs CameraRight = 0.998965
  Arg4 vs RootRight   = 0.999383
  Arg4 vs CameraLook  = -0.045481
  Arg4 vs RootLook    = -0.035122
  Arg4 vs HumMove     = -0.731500

ACCEL #81 t=1.7229 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (307.761,0.000,2758.104) mag= 2775.221191
  WishDir    = (0.998,0.000,-0.060) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007801
  Dot(Vel,Wish) = 140.478455
  addSpeed = 41.521545
  accelSpeed(x10) = 2584.086079
  expectedAdd = 41.521545
  RETURN     = (349.207,0.000,2755.594)
  DELTA      = (41.446,0.000,-2.510) mag= 41.521538
  CameraLook = (0.060,0.000,0.998) angle= 90.000000
  CameraRight= (-0.998,0.000,0.060) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (0.045,0.000,0.999) angle= 90.858309
  RootRight  = (-0.999,0.000,0.045) dot= -0.999888
  Wish(root basis): Right= -0.999888 Forward= -0.014980
  HumMove    = (0.739,0.000,0.674) angle= 45.858694

AIRCONTROL #63 t=1.7229 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.998,0.000,-0.060)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (349.207,0.000,2755.594)
  Arg6 = 0.007801
  RETURN = (349.207,0.000,2755.594)
  Arg4 vs CameraRight = 0.998171
  Arg4 vs RootRight   = 0.998965
  Arg4 vs CameraLook  = -0.060447
  Arg4 vs RootLook    = -0.045488
  Arg4 vs HumMove     = -0.738535

ACCEL #82 t=1.7316 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (349.207,0.000,2755.594) mag= 2777.632324
  WishDir    = (0.997,0.000,-0.077) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008817
  Dot(Vel,Wish) = 137.244278
  addSpeed = 44.755722
  accelSpeed(x10) = 2920.611978
  expectedAdd = 44.755722
  RETURN     = (393.831,0.000,2752.168)
  DELTA      = (44.624,0.000,-3.426) mag= 44.755714
  CameraLook = (0.077,0.000,0.997) angle= 90.000000
  CameraRight= (-0.997,0.000,0.077) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.060,0.000,0.998) angle= 90.924326
  RootRight  = (-0.998,0.000,0.060) dot= -0.999870
  Wish(root basis): Right= -0.999870 Forward= -0.016132
  HumMove    = (0.749,0.000,0.663) angle= 45.924735

AIRCONTROL #64 t=1.7317 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.997,0.000,-0.077)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (393.831,0.000,2752.168)
  Arg6 = 0.008817
  RETURN = (393.831,0.000,2752.168)
  Arg4 vs CameraRight = 0.997066
  Arg4 vs RootRight   = 0.998171
  Arg4 vs CameraLook  = -0.076549
  Arg4 vs RootLook    = -0.060454
  Arg4 vs HumMove     = -0.748556

ACCEL #83 t=1.7399 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (393.831,0.000,2752.168) mag= 2780.203125
  WishDir    = (0.995,0.000,-0.096) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008437
  Dot(Vel,Wish) = 127.598267
  addSpeed = 54.401733
  accelSpeed(x10) = 2794.644187
  expectedAdd = 54.401733
  RETURN     = (447.981,0.000,2746.941)
  DELTA      = (54.150,0.000,-5.227) mag= 54.401733
  CameraLook = (0.096,0.000,0.995) angle= 90.000000
  CameraRight= (-0.995,0.000,0.096) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (0.077,0.000,0.997) angle= 91.122455
  RootRight  = (-0.997,0.000,0.077) dot= -0.999808
  Wish(root basis): Right= -0.999808 Forward= -0.019589
  HumMove    = (0.759,0.000,0.651) angle= 46.122889

AIRCONTROL #65 t=1.7399 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.995,0.000,-0.096)
  Arg3 = 1619.999903
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (447.981,0.000,2746.941)
  Arg6 = 0.008437
  RETURN = (447.981,0.000,2746.941)
  Arg4 vs CameraRight = 0.995374
  Arg4 vs RootRight   = 0.997065
  Arg4 vs CameraLook  = -0.096074
  Arg4 vs RootLook    = -0.076557
  Arg4 vs HumMove     = -0.759160

ACCEL #84 t=1.7478 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (447.981,0.000,2746.941) mag= 2783.230469
  WishDir    = (0.993,0.000,-0.116) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007700
  Dot(Vel,Wish) = 127.538849
  addSpeed = 54.461151
  accelSpeed(x10) = 2550.658426
  expectedAdd = 54.461151
  RETURN     = (502.077,0.000,2740.647)
  DELTA      = (54.096,0.000,-6.294) mag= 54.461163
  CameraLook = (0.116,0.000,0.993) angle= 90.000000
  CameraRight= (-0.993,0.000,0.116) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.096,0.000,0.995) angle= 91.122393
  RootRight  = (-0.995,0.000,0.096) dot= -0.999808
  Wish(root basis): Right= -0.999808 Forward= -0.019588
  HumMove    = (0.772,0.000,0.636) angle= 46.122898

AIRCONTROL #66 t=1.7478 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.993,0.000,-0.116)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (502.077,0.000,2740.647)
  Arg6 = 0.007700
  RETURN = (502.077,0.000,2740.647)
  Arg4 vs CameraRight = 0.993300
  Arg4 vs RootRight   = 0.995373
  Arg4 vs CameraLook  = -0.115562
  Arg4 vs RootLook    = -0.096082
  Arg4 vs HumMove     = -0.771770

ACCEL #85 t=1.7561 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (502.077,0.000,2740.647) mag= 2786.257324
  WishDir    = (0.991,0.000,-0.134) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008315
  Dot(Vel,Wish) = 130.687866
  addSpeed = 51.312134
  accelSpeed(x10) = 2754.163960
  expectedAdd = 51.312134
  RETURN     = (552.928,0.000,2733.779)
  DELTA      = (50.850,0.000,-6.869) mag= 51.312172
  CameraLook = (0.134,0.000,0.991) angle= 90.000000
  CameraRight= (-0.991,0.000,0.134) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.116,0.000,0.993) angle= 91.056336
  RootRight  = (-0.993,0.000,0.116) dot= -0.999830
  Wish(root basis): Right= -0.999830 Forward= -0.018435
  HumMove    = (0.784,0.000,0.621) angle= 46.056841

AIRCONTROL #67 t=1.7561 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.991,0.000,-0.134)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (552.928,0.000,2733.779)
  Arg6 = 0.008315
  RETURN = (552.928,0.000,2733.779)
  Arg4 vs CameraRight = 0.991000
  Arg4 vs RootRight   = 0.993299
  Arg4 vs CameraLook  = -0.133863
  Arg4 vs RootLook    = -0.115570
  Arg4 vs HumMove     = -0.784084

ACCEL #86 t=1.7643 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (552.928,0.000,2733.779) mag= 2789.135010
  WishDir    = (0.987,0.000,-0.158) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008332
  Dot(Vel,Wish) = 114.572998
  addSpeed = 67.427002
  accelSpeed(x10) = 2759.933056
  expectedAdd = 67.427002
  RETURN     = (619.510,0.000,2723.138)
  DELTA      = (66.582,0.000,-10.641) mag= 67.427017
  CameraLook = (0.158,0.000,0.987) angle= 90.000001
  CameraRight= (-0.987,0.000,0.158) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (0.134,0.000,0.991) angle= 91.386611
  RootRight  = (-0.991,0.000,0.134) dot= -0.999707
  Wish(root basis): Right= -0.999707 Forward= -0.024199
  HumMove    = (0.795,0.000,0.606) angle= 46.387110

AIRCONTROL #68 t=1.7644 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.987,0.000,-0.158)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (619.510,0.000,2723.138)
  Arg6 = 0.008332
  RETURN = (619.510,0.000,2723.138)
  Arg4 vs CameraRight = 0.987469
  Arg4 vs RootRight   = 0.990999
  Arg4 vs CameraLook  = -0.157813
  Arg4 vs RootLook    = -0.133872
  Arg4 vs HumMove     = -0.795398

ACCEL #87 t=1.7811 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (619.510,0.000,2723.138) mag= 2792.717529
  WishDir    = (0.982,0.000,-0.188) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.016640
  Dot(Vel,Wish) = 95.182434
  addSpeed = 86.817566
  accelSpeed(x10) = 5511.833615
  expectedAdd = 86.817566
  RETURN     = (704.771,0.000,2706.775)
  DELTA      = (85.262,0.000,-16.362) mag= 86.817543
  CameraLook = (0.188,0.000,0.982) angle= 90.000000
  CameraRight= (-0.982,0.000,0.188) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.158,0.000,0.987) angle= 91.782845
  RootRight  = (-0.987,0.000,0.158) dot= -0.999516
  Wish(root basis): Right= -0.999516 Forward= -0.031111
  HumMove    = (0.810,0.000,0.587) angle= 46.783431

AIRCONTROL #69 t=1.7812 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.982,0.000,-0.188)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (704.771,0.000,2706.775)
  Arg6 = 0.016640
  RETURN = (704.771,0.000,2706.775)
  Arg4 vs CameraRight = 0.982079
  Arg4 vs RootRight   = 0.987467
  Arg4 vs CameraLook  = -0.188468
  Arg4 vs RootLook    = -0.157823
  Arg4 vs HumMove     = -0.809837

ACCEL #88 t=1.7893 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (704.771,0.000,2706.775) mag= 2797.022705
  WishDir    = (0.969,0.000,-0.247) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008336
  Dot(Vel,Wish) = 14.454102
  addSpeed = 167.545898
  accelSpeed(x10) = 2761.327128
  expectedAdd = 167.545898
  RETURN     = (867.127,0.000,2665.397)
  DELTA      = (162.356,0.000,-41.378) mag= 167.545914
  CameraLook = (0.247,0.000,0.969) angle= 90.000000
  CameraRight= (-0.969,0.000,0.247) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.188,0.000,0.982) angle= 93.433706
  RootRight  = (-0.982,0.000,0.188) dot= -0.998205
  Wish(root basis): Right= -0.998205 Forward= -0.059894
  HumMove    = (0.828,0.000,0.561) angle= 48.434733

AIRCONTROL #70 t=1.7893 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.969,0.000,-0.247)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (867.127,0.000,2665.397)
  Arg6 = 0.008336
  RETURN = (867.127,0.000,2665.397)
  Arg4 vs CameraRight = 0.969024
  Arg4 vs RootRight   = 0.982076
  Arg4 vs CameraLook  = -0.246968
  Arg4 vs RootLook    = -0.188486
  Arg4 vs HumMove     = -0.827702

ACCEL #89 t=1.7983 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (867.127,0.000,2665.397) mag= 2802.900391
  WishDir    = (0.963,0.000,-0.269) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.009007
  Dot(Vel,Wish) = 117.467957
  addSpeed = 64.532043
  accelSpeed(x10) = 2983.381934
  expectedAdd = 64.532043
  RETURN     = (929.276,0.000,2648.022)
  DELTA      = (62.149,0.000,-17.375) mag= 64.532059
  CameraLook = (0.269,0.000,0.963) angle= 90.000000
  CameraRight= (-0.963,0.000,0.269) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.247,0.000,0.969) angle= 91.320074
  RootRight  = (-0.969,0.000,0.247) dot= -0.999735
  Wish(root basis): Right= -0.999735 Forward= -0.023038
  HumMove    = (0.860,0.000,0.511) angle= 46.321052

AIRCONTROL #71 t=1.7984 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.963,0.000,-0.269)
  Arg3 = 1619.999903
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (929.276,0.000,2648.022)
  Arg6 = 0.009007
  RETURN = (929.276,0.000,2648.022)
  Arg4 vs CameraRight = 0.963072
  Arg4 vs RootRight   = 0.969019
  Arg4 vs CameraLook  = -0.269243
  Arg4 vs RootLook    = -0.246984
  Arg4 vs HumMove     = -0.859836

ACCEL #90 t=1.8066 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (929.276,0.000,2648.022) mag= 2806.345703
  WishDir    = (0.957,0.000,-0.290) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008268
  Dot(Vel,Wish) = 120.620544
  addSpeed = 61.379456
  accelSpeed(x10) = 2738.678623
  expectedAdd = 61.379456
  RETURN     = (988.013,0.000,2630.206)
  DELTA      = (58.737,0.000,-17.817) mag= 61.379471
  CameraLook = (0.290,0.000,0.957) angle= 89.999998
  CameraRight= (-0.957,0.000,0.290) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.269,0.000,0.963) angle= 91.254266
  RootRight  = (-0.963,0.000,0.269) dot= -0.999760
  Wish(root basis): Right= -0.999760 Forward= -0.021889
  HumMove    = (0.871,0.000,0.491) angle= 46.255001

AIRCONTROL #72 t=1.8067 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.957,0.000,-0.290)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (988.013,0.000,2630.206)
  Arg6 = 0.008268
  RETURN = (988.013,0.000,2630.206)
  Arg4 vs CameraRight = 0.956944
  Arg4 vs RootRight   = 0.963069
  Arg4 vs CameraLook  = -0.290271
  Arg4 vs RootLook    = -0.269255
  Arg4 vs HumMove     = -0.871378

ACCEL #91 t=1.8144 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (988.013,0.000,2630.206) mag= 2809.653320
  WishDir    = (0.946,0.000,-0.323) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007749
  Dot(Vel,Wish) = 84.942017
  addSpeed = 97.057983
  accelSpeed(x10) = 2566.916842
  expectedAdd = 97.057983
  RETURN     = (1079.863,0.000,2598.838)
  DELTA      = (91.849,0.000,-31.368) mag= 97.057983
  CameraLook = (0.323,0.000,0.946) angle= 90.000002
  CameraRight= (-0.946,0.000,0.323) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (0.290,0.000,0.957) angle= 91.980955
  RootRight  = (-0.957,0.000,0.290) dot= -0.999402
  Wish(root basis): Right= -0.999402 Forward= -0.034567
  HumMove    = (0.882,0.000,0.471) angle= 46.981584

AIRCONTROL #73 t=1.8144 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.946,0.000,-0.323)
  Arg3 = 1619.999903
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (1079.863,0.000,2598.838)
  Arg6 = 0.007749
  RETURN = (1079.863,0.000,2598.838)
  Arg4 vs CameraRight = 0.946335
  Arg4 vs RootRight   = 0.956941
  Arg4 vs CameraLook  = -0.323187
  Arg4 vs RootLook    = -0.290282
  Arg4 vs HumMove     = -0.881915

ACCEL #92 t=1.8227 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1079.863,0.000,2598.838) mag= 2814.260010
  WishDir    = (0.934,0.000,-0.358) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008298
  Dot(Vel,Wish) = 78.296875
  addSpeed = 103.703125
  accelSpeed(x10) = 2748.615744
  expectedAdd = 103.703125
  RETURN     = (1176.698,0.000,2561.725)
  DELTA      = (96.835,0.000,-37.112) mag= 103.703102
  CameraLook = (0.358,0.000,0.934) angle= 90.000000
  CameraRight= (-0.934,0.000,0.358) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.323,0.000,0.946) angle= 92.112942
  RootRight  = (-0.946,0.000,0.323) dot= -0.999320
  Wish(root basis): Right= -0.999320 Forward= -0.036869
  HumMove    = (0.898,0.000,0.441) angle= 47.113682

AIRCONTROL #74 t=1.8228 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.934,0.000,-0.358)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (1176.698,0.000,2561.725)
  Arg6 = 0.008298
  RETURN = (1176.698,0.000,2561.725)
  Arg4 vs CameraRight = 0.933771
  Arg4 vs RootRight   = 0.946331
  Arg4 vs CameraLook  = -0.357871
  Arg4 vs RootLook    = -0.323200
  Arg4 vs HumMove     = -0.897688

ACCEL #93 t=1.8308 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1176.698,0.000,2561.725) mag= 2819.051758
  WishDir    = (0.920,0.000,-0.391) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008287
  Dot(Vel,Wish) = 81.368164
  addSpeed = 100.631836
  accelSpeed(x10) = 2744.820376
  expectedAdd = 100.631836
  RETURN     = (1269.318,0.000,2522.378)
  DELTA      = (92.620,0.000,-39.348) mag= 100.631851
  CameraLook = (0.391,0.000,0.920) angle= 90.000000
  CameraRight= (-0.920,0.000,0.391) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.358,0.000,0.934) angle= 92.046828
  RootRight  = (-0.934,0.000,0.358) dot= -0.999362
  Wish(root basis): Right= -0.999362 Forward= -0.035716
  HumMove    = (0.913,0.000,0.407) angle= 47.047633

AIRCONTROL #75 t=1.8308 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.920,0.000,-0.391)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (1269.318,0.000,2522.378)
  Arg6 = 0.008287
  RETURN = (1269.318,0.000,2522.378)
  Arg4 vs CameraRight = 0.920388
  Arg4 vs RootRight   = 0.933766
  Arg4 vs CameraLook  = -0.391006
  Arg4 vs RootLook    = -0.357884
  Arg4 vs HumMove     = -0.913329

ACCEL #94 t=1.8396 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1269.318,0.000,2522.378) mag= 2823.748779
  WishDir    = (0.906,0.000,-0.424) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008844
  Dot(Vel,Wish) = 81.199951
  addSpeed = 100.800049
  accelSpeed(x10) = 2929.376215
  expectedAdd = 100.800049
  RETURN     = (1360.625,0.000,2479.675)
  DELTA      = (91.308,0.000,-42.703) mag= 100.799988
  CameraLook = (0.424,0.000,0.906) angle= 89.999998
  CameraRight= (-0.906,0.000,0.424) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.391,0.000,0.920) angle= 92.046821
  RootRight  = (-0.920,0.000,0.391) dot= -0.999362
  Wish(root basis): Right= -0.999362 Forward= -0.035716
  HumMove    = (0.927,0.000,0.374) angle= 47.047633

AIRCONTROL #76 t=1.8396 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.906,0.000,-0.424)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (1360.625,0.000,2479.675)
  Arg6 = 0.008844
  RETURN = (1360.625,0.000,2479.675)
  Arg4 vs CameraRight = 0.905830
  Arg4 vs RootRight   = 0.920382
  Arg4 vs CameraLook  = -0.423642
  Arg4 vs RootLook    = -0.391019
  Arg4 vs HumMove     = -0.927296

ACCEL #95 t=1.8477 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1360.625,0.000,2479.675) mag= 2828.442627
  WishDir    = (0.890,0.000,-0.457) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007887
  Dot(Vel,Wish) = 77.771973
  addSpeed = 104.228027
  accelSpeed(x10) = 2612.434732
  expectedAdd = 104.228027
  RETURN     = (1453.345,0.000,2432.067)
  DELTA      = (92.720,0.000,-47.608) mag= 104.228027
  CameraLook = (0.457,0.000,0.890) angle= 89.999998
  CameraRight= (-0.890,0.000,0.457) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.424,0.000,0.906) angle= 92.112869
  RootRight  = (-0.906,0.000,0.424) dot= -0.999320
  Wish(root basis): Right= -0.999320 Forward= -0.036868
  HumMove    = (0.940,0.000,0.341) angle= 47.113696

AIRCONTROL #77 t=1.8477 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.890,0.000,-0.457)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (1453.345,0.000,2432.067)
  Arg6 = 0.007887
  RETURN = (1453.345,0.000,2432.067)
  Arg4 vs CameraRight = 0.889588
  Arg4 vs RootRight   = 0.905823
  Arg4 vs CameraLook  = -0.456763
  Arg4 vs RootLook    = -0.423655
  Arg4 vs HumMove     = -0.940079

ACCEL #96 t=1.8559 state=Enum.HumanoidStateType.Landed callerLine=305
  callerSource = =Opiumware
  Velocity   = (1453.345,0.000,2432.067) mag= 2833.224854
  WishDir    = (0.875,0.000,-0.483) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008252
  Dot(Vel,Wish) = 97.183960
  addSpeed = 84.816040
  accelSpeed(x10) = 2733.282185
  expectedAdd = 84.816040
  RETURN     = (1527.602,0.000,2391.082)
  DELTA      = (74.256,0.000,-40.985) mag= 84.816055
  CameraLook = (0.483,0.000,0.875) angle= 89.999998
  CameraRight= (-0.875,0.000,0.483) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.457,0.000,0.890) angle= 91.716185
  RootRight  = (-0.890,0.000,0.457) dot= -0.999552
  Wish(root basis): Right= -0.999552 Forward= -0.029949
  HumMove    = (0.952,0.000,0.306) angle= 46.717363

AIRCONTROL #78 t=1.8559 state=Enum.HumanoidStateType.Landed callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.875,0.000,-0.483)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (1527.602,0.000,2391.082)
  Arg6 = 0.008252
  RETURN = (1527.602,0.000,2391.082)
  Arg4 vs CameraRight = 0.875500
  Arg4 vs RootRight   = 0.889579
  Arg4 vs CameraLook  = -0.483219
  Arg4 vs RootLook    = -0.456782
  Arg4 vs HumMove     = -0.952014

ACCEL #97 t=1.8643 state=Enum.HumanoidStateType.Landed callerLine=305
  callerSource = =Opiumware
  Velocity   = (1527.602,0.000,2391.082) mag= 2837.400635
  WishDir    = (0.862,0.000,-0.506) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008368
  Dot(Vel,Wish) = 106.865234
  addSpeed = 75.134766
  accelSpeed(x10) = 2771.885242
  expectedAdd = 75.134766
  RETURN     = (1592.397,0.000,2353.044)
  DELTA      = (64.795,0.000,-38.038) mag= 75.134834
  CameraLook = (0.506,0.000,0.862) angle= 89.999997
  CameraRight= (-0.862,0.000,0.506) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.483,0.000,0.875) angle= 91.517840
  RootRight  = (-0.875,0.000,0.483) dot= -0.999649
  Wish(root basis): Right= -0.999649 Forward= -0.026488
  HumMove    = (0.961,0.000,0.277) angle= 46.519212

AIRCONTROL #79 t=1.8643 state=Enum.HumanoidStateType.Landed callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.862,0.000,-0.506)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (1592.397,0.000,2353.044)
  Arg6 = 0.008368
  RETURN = (1592.397,0.000,2353.044)
  Arg4 vs CameraRight = 0.862381
  Arg4 vs RootRight   = 0.875488
  Arg4 vs CameraLook  = -0.506260
  Arg4 vs RootLook    = -0.483240
  Arg4 vs HumMove     = -0.960759

ACCEL #98 t=1.8730 state=Enum.HumanoidStateType.Landed callerLine=305
  callerSource = =Opiumware
  Velocity   = (1592.397,0.000,2353.044) mag= 2841.222412
  WishDir    = (0.836,0.000,-0.549) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008864
  Dot(Vel,Wish) = 38.002808
  addSpeed = 143.997192
  accelSpeed(x10) = 2936.180299
  expectedAdd = 143.997192
  RETURN     = (1712.721,0.000,2273.942)
  DELTA      = (120.324,0.000,-79.103) mag= 143.997177
  CameraLook = (0.549,0.000,0.836) angle= 90.000002
  CameraRight= (-0.836,0.000,0.549) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (0.506,0.000,0.862) angle= 92.905038
  RootRight  = (-0.862,0.000,0.506) dot= -0.998715
  Wish(root basis): Right= -0.998715 Forward= -0.050681
  HumMove    = (0.968,0.000,0.252) angle= 47.906320

AIRCONTROL #80 t=1.8730 state=Enum.HumanoidStateType.Landed callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.836,0.000,-0.549)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (1712.721,0.000,2273.942)
  Arg6 = 0.008864
  RETURN = (1712.721,0.000,2273.942)
  Arg4 vs CameraRight = 0.835603
  Arg4 vs RootRight   = 0.862369
  Arg4 vs CameraLook  = -0.549334
  Arg4 vs RootLook    = -0.506279
  Arg4 vs HumMove     = -0.967775

ACCEL #99 t=1.8810 state=Enum.HumanoidStateType.Landed callerLine=305
  callerSource = =Opiumware
  Velocity   = (1712.721,0.000,2273.942) mag= 2846.792236
  WishDir    = (0.803,0.000,-0.597) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007832
  Dot(Vel,Wish) = 18.029907
  addSpeed = 163.970093
  accelSpeed(x10) = 2594.326911
  expectedAdd = 163.970093
  RETURN     = (1844.318,0.000,2176.124)
  DELTA      = (131.597,0.000,-97.818) mag= 163.970123
  CameraLook = (0.597,0.000,0.803) angle= 90.000000
  CameraRight= (-0.803,0.000,0.597) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.549,0.000,0.836) angle= 93.301099
  RootRight  = (-0.836,0.000,0.549) dot= -0.998341
  Wish(root basis): Right= -0.998341 Forward= -0.057583
  HumMove    = (0.979,0.000,0.202) angle= 48.302627

AIRCONTROL #81 t=1.8811 state=Enum.HumanoidStateType.Landed callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.803,0.000,-0.597)
  Arg3 = 1620.000000
  Arg4 = (-1.000,0.000,-0.000)
  Arg5 = (1844.318,0.000,2176.124)
  Arg6 = 0.007832
  RETURN = (1844.318,0.000,2176.124)
  Arg4 vs CameraRight = 0.802568
  Arg4 vs RootRight   = 0.835588
  Arg4 vs CameraLook  = -0.596561
  Arg4 vs RootLook    = -0.549357
  Arg4 vs HumMove     = -0.979298

ACCEL #100 t=1.8893 state=Enum.HumanoidStateType.Landed callerLine=305
  callerSource = =Opiumware
  Velocity   = (1767.109,0.000,2085.024) mag= 2733.129883
  WishDir    = (1.000,0.000,0.030) mag= 1.000000
  Accel      = 2858.321227
  WishSpeed  = 20.400000
  dt         = 0.008373
  Dot(Vel,Wish) = 1828.024170
  addSpeed = -1807.624170
  accelSpeed(x10) = 4882.081051
  expectedAdd = 0.000000
  RETURN     = (2255.103,0.000,2099.468)
  DELTA      = (487.994,0.000,14.444) mag= 488.208008
  CameraLook = (0.625,0.000,0.781) angle= 49.632933
  CameraRight= (-0.781,0.000,0.625) dot= -0.761911
  Wish(cam basis): Right= -0.761911 Forward= 0.647682
  RootLook   = (0.597,0.000,0.803) angle= 51.678825
  RootRight  = (-0.803,0.000,0.597) dot= -0.784547
  Wish(root basis): Right= -0.784547 Forward= 0.620069
  HumMove    = (0.989,0.000,0.146) angle= 6.680521

ACCEL #101 t=1.8975 state=Enum.HumanoidStateType.Landed callerLine=305
  callerSource = =Opiumware
  Velocity   = (2161.923,0.000,2012.719) mag= 2953.802734
  WishDir    = (1.000,0.000,-0.002) mag= 1.000000
  Accel      = 2869.700811
  WishSpeed  = 20.400000
  dt         = 0.008264
  Dot(Vel,Wish) = 2157.923096
  addSpeed = -2137.523096
  accelSpeed(x10) = 4837.853570
  expectedAdd = 0.000000
  RETURN     = (2645.708,0.000,2011.759)
  DELTA      = (483.784,0.000,-0.960) mag= 483.785370
  CameraLook = (0.650,0.000,0.760) angle= 49.592648
  CameraRight= (-0.760,0.000,0.650) dot= -0.761455
  Wish(cam basis): Right= -0.761455 Forward= 0.648218
  RootLook   = (0.625,0.000,0.781) angle= 51.439203
  RootRight  = (-0.781,0.000,0.625) dot= -0.781947
  Wish(root basis): Right= -0.781947 Forward= 0.623345
  HumMove    = (0.994,0.000,0.110) angle= 6.442112

ACCEL #102 t=1.9059 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (2535.119,0.000,1927.669) mag= 3184.766357
  WishDir    = (1.000,0.000,-0.021) mag= 1.000000
  Accel      = 2881.212302
  WishSpeed  = 20.400000
  dt         = 0.008360
  Dot(Vel,Wish) = 2493.619873
  addSpeed = -2473.219873
  accelSpeed(x10) = 4913.636916
  expectedAdd = 0.000000
  RETURN     = (2922.625,0.000,1919.439)
  DELTA      = (387.505,0.000,-8.229) mag= 387.592499
  CameraLook = (0.665,0.000,0.747) angle= 49.572583
  CameraRight= (-0.747,0.000,0.665) dot= -0.761228
  Wish(cam basis): Right= -0.761228 Forward= 0.648484
  RootLook   = (0.650,0.000,0.760) angle= 50.691984
  RootRight  = (-0.760,0.000,0.650) dot= -0.773752
  Wish(root basis): Right= -0.773752 Forward= 0.633489
  HumMove    = (0.997,0.000,0.078) angle= 5.695433

ACCEL #103 t=1.9150 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (2792.234,0.000,1833.805) mag= 3340.570801
  WishDir    = (0.999,0.000,-0.039) mag= 1.000000
  Accel      = 2893.499043
  WishSpeed  = 20.400000
  dt         = 0.008923
  Dot(Vel,Wish) = 2717.970947
  addSpeed = -2697.570947
  accelSpeed(x10) = 5266.914595
  expectedAdd = 0.000000
  RETURN     = (2967.626,0.000,1826.904)
  DELTA      = (175.392,0.000,-6.902) mag= 175.528076
  CameraLook = (0.678,0.000,0.735) angle= 49.552563
  CameraRight= (-0.735,0.000,0.678) dot= -0.761001
  Wish(cam basis): Right= -0.761001 Forward= 0.648750
  RootLook   = (0.665,0.000,0.747) angle= 50.605930
  RootRight  = (-0.747,0.000,0.665) dot= -0.772799
  Wish(root basis): Right= -0.772799 Forward= 0.634651
  HumMove    = (0.998,0.000,0.059) angle= 5.609373

ACCEL #104 t=1.9225 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (2852.466,0.000,1756.010) mag= 3349.646484
  WishDir    = (0.998,0.000,-0.055) mag= 1.000000
  Accel      = 2904.186112
  WishSpeed  = 20.400000
  dt         = 0.007761
  Dot(Vel,Wish) = 2751.390381
  addSpeed = -2730.990381
  accelSpeed(x10) = 4598.109286
  expectedAdd = 0.000000
  RETURN     = (3005.030,0.000,1747.592)
  DELTA      = (152.564,0.000,-8.418) mag= 152.795776
  CameraLook = (0.690,0.000,0.724) angle= 49.532590
  CameraRight= (-0.724,0.000,0.690) dot= -0.760775
  Wish(cam basis): Right= -0.760775 Forward= 0.649015
  RootLook   = (0.678,0.000,0.735) angle= 50.454614
  RootRight  = (-0.735,0.000,0.678) dot= -0.771120
  Wish(root basis): Right= -0.771120 Forward= 0.636689
  HumMove    = (0.999,0.000,0.040) angle= 5.457292

ACCEL #105 t=1.9316 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (2871.943,0.000,1670.194) mag= 3322.289307
  WishDir    = (0.998,0.000,-0.062) mag= 1.000000
  Accel      = 2916.382831
  WishSpeed  = 20.400000
  dt         = 0.008858
  Dot(Vel,Wish) = 2762.869873
  addSpeed = -2742.469873
  accelSpeed(x10) = 5269.749382
  expectedAdd = 0.000000
  RETURN     = (3025.161,0.000,1660.677)
  DELTA      = (153.218,0.000,-9.517) mag= 153.512848
  CameraLook = (0.695,0.000,0.719) angle= 49.532594
  CameraRight= (-0.719,0.000,0.695) dot= -0.760775
  Wish(cam basis): Right= -0.760775 Forward= 0.649015
  RootLook   = (0.690,0.000,0.724) angle= 49.926552
  RootRight  = (-0.724,0.000,0.690) dot= -0.765220
  Wish(root basis): Right= -0.765220 Forward= 0.643769
  HumMove    = (1.000,0.000,0.024) angle= 4.928792

ACCEL #106 t=1.9397 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (3249.662,0.000,1783.918) mag= 3707.110352
  WishDir    = (0.998,0.000,-0.062) mag= 1.000000
  Accel      = 2927.189355
  WishSpeed  = 20.400000
  dt         = 0.007848
  Dot(Vel,Wish) = 3132.811523
  addSpeed = -3112.411523
  accelSpeed(x10) = 4686.332309
  expectedAdd = 0.000000
  RETURN     = (3249.662,0.000,1783.918)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (0.695,0.000,0.719) angle= 49.532594
  CameraRight= (-0.719,0.000,0.695) dot= -0.760775
  Wish(cam basis): Right= -0.760775 Forward= 0.649015
  RootLook   = (0.695,0.000,0.719) angle= 49.530377
  RootRight  = (-0.719,0.000,0.695) dot= -0.760750
  Wish(root basis): Right= -0.760750 Forward= 0.649045
  HumMove    = (1.000,0.000,0.017) angle= 4.532504

ACCEL #107 t=1.9482 state=Enum.HumanoidStateType.Jumping callerLine=305
  callerSource = =Opiumware
  Velocity   = (3106.573,0.000,1705.369) mag= 3543.879395
  WishDir    = (0.695,0.000,0.719) mag= 1.000000
  Accel      = 2939.315557
  WishSpeed  = 20.400000
  dt         = 0.008806
  Dot(Vel,Wish) = 3385.147705
  addSpeed = -3364.747705
  accelSpeed(x10) = 5280.481781
  expectedAdd = 0.000000
  RETURN     = (3106.573,0.000,1705.369)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (0.695,0.000,0.719) angle= 0.027976
  CameraRight= (-0.719,0.000,0.695) dot= 0.000000
  Wish(cam basis): Right= 0.000000 Forward= 1.000000
  RootLook   = (0.695,0.000,0.719) angle= 0.000000
  RootRight  = (-0.719,0.000,0.695) dot= 0.000047
  Wish(root basis): Right= 0.000047 Forward= 1.000000
  HumMove    = (0.695,0.000,0.719) angle= 0.000000

AIRCONTROL #82 t=1.9561 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.000,0.000,0.000)
  Arg3 = 0.000000
  Arg4 = (0.000,0.000,-0.000)
  Arg5 = (3106.573,0.000,1705.369)
  Arg6 = 0.008181
  RETURN = (3106.573,0.000,1705.369)
  Arg4 vs CameraRight = 0.000000
  Arg4 vs RootRight   = 0.000000
  Arg4 vs CameraLook  = 0.000000
  Arg4 vs RootLook    = 0.000000
  Arg4 vs HumMove     = 0.000000

AIRCONTROL #83 t=1.9645 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.000,0.000,0.000)
  Arg3 = 0.000000
  Arg4 = (0.000,0.000,-0.000)
  Arg5 = (3106.573,0.000,1705.369)
  Arg6 = 0.007971
  RETURN = (3106.573,0.000,1705.369)
  Arg4 vs CameraRight = 0.000000
  Arg4 vs RootRight   = 0.000000
  Arg4 vs CameraLook  = 0.000000
  Arg4 vs RootLook    = 0.000000
  Arg4 vs HumMove     = 0.000000

AIRCONTROL #84 t=1.9726 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.000,0.000,0.000)
  Arg3 = 0.000000
  Arg4 = (0.000,0.000,-0.000)
  Arg5 = (3106.573,0.000,1705.369)
  Arg6 = 0.008376
  RETURN = (3106.573,0.000,1705.369)
  Arg4 vs CameraRight = 0.000000
  Arg4 vs RootRight   = 0.000000
  Arg4 vs CameraLook  = 0.000000
  Arg4 vs RootLook    = 0.000000
  Arg4 vs HumMove     = 0.000000

AIRCONTROL #85 t=1.9809 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (0.000,0.000,0.000)
  Arg3 = 0.000000
  Arg4 = (0.000,0.000,-0.000)
  Arg5 = (3106.573,0.000,1705.369)
  Arg6 = 0.008318
  RETURN = (3106.573,0.000,1705.369)
  Arg4 vs CameraRight = 0.000000
  Arg4 vs RootRight   = 0.000000
  Arg4 vs CameraLook  = 0.000000
  Arg4 vs RootLook    = 0.000000
  Arg4 vs HumMove     = 0.000000

ACCEL #108 t=1.9900 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3106.573,0.000,1705.369) mag= 3543.879395
  WishDir    = (-0.763,0.000,0.646) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008291
  Dot(Vel,Wish) = -1268.760254
  addSpeed = 1450.760254
  accelSpeed(x10) = 2746.158920
  expectedAdd = 1450.760254
  RETURN     = (2896.999,0.000,1882.830)
  DELTA      = (-209.574,0.000,177.461) mag= 274.615875
  CameraLook = (0.646,0.000,0.763) angle= 90.000000
  CameraRight= (-0.763,0.000,0.646) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.675,0.000,0.738) angle= 92.180087
  RootRight  = (-0.738,0.000,0.675) dot= 0.999276
  Wish(root basis): Right= 0.999276 Forward= -0.038041
  HumMove    = (-0.045,0.000,0.999) angle= 47.179743

AIRCONTROL #86 t=1.9901 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.763,0.000,0.646)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2896.999,0.000,1882.830)
  Arg6 = 0.008291
  RETURN = (2896.999,0.000,1882.830)
  Arg4 vs CameraRight = -0.763155
  Arg4 vs RootRight   = -0.738020
  Arg4 vs CameraLook  = 0.646216
  Arg4 vs RootLook    = 0.674779
  Arg4 vs HumMove     = -0.044724

ACCEL #109 t=1.9983 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2896.999,0.000,1882.830) mag= 3455.090820
  WishDir    = (-0.787,0.000,0.617) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008954
  Dot(Vel,Wish) = -1119.281006
  addSpeed = 1301.281006
  accelSpeed(x10) = 2965.909296
  expectedAdd = 1301.281006
  RETURN     = (2663.528,0.000,2065.744)
  DELTA      = (-233.471,0.000,182.914) mag= 296.590912
  CameraLook = (0.617,0.000,0.787) angle= 89.999997
  CameraRight= (-0.787,0.000,0.617) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.646,0.000,0.763) angle= 92.178865
  RootRight  = (-0.763,0.000,0.646) dot= 0.999277
  Wish(root basis): Right= 0.999277 Forward= -0.038019
  HumMove    = (-0.083,0.000,0.997) angle= 47.179748

AIRCONTROL #87 t=1.9983 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.787,0.000,0.617)
  Arg3 = 1619.999903
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2663.528,0.000,2065.744)
  Arg6 = 0.008954
  RETURN = (2663.528,0.000,2065.744)
  Arg4 vs CameraRight = -0.787181
  Arg4 vs RootRight   = -0.763165
  Arg4 vs CameraLook  = 0.616722
  Arg4 vs RootLook    = 0.646204
  Arg4 vs HumMove     = -0.082688

ACCEL #110 t=2.0065 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2663.528,0.000,2065.744) mag= 3370.709473
  WishDir    = (-0.807,0.000,0.591) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008341
  Dot(Vel,Wish) = -927.756958
  addSpeed = 1109.756958
  accelSpeed(x10) = 2762.720891
  expectedAdd = 1109.756958
  RETURN     = (2440.667,0.000,2229.020)
  DELTA      = (-222.862,0.000,163.275) mag= 276.272034
  CameraLook = (0.591,0.000,0.807) angle= 90.000000
  CameraRight= (-0.807,0.000,0.591) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.617,0.000,0.787) angle= 91.848044
  RootRight  = (-0.787,0.000,0.617) dot= 0.999480
  Wish(root basis): Right= 0.999480 Forward= -0.032249
  HumMove    = (-0.121,0.000,0.993) angle= 46.849474

AIRCONTROL #88 t=2.0066 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.807,0.000,0.591)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2440.667,0.000,2229.020)
  Arg6 = 0.008341
  RETURN = (2440.667,0.000,2229.020)
  Arg4 vs CameraRight = -0.806675
  Arg4 vs RootRight   = -0.787197
  Arg4 vs CameraLook  = 0.590995
  Arg4 vs RootLook    = 0.616702
  Arg4 vs HumMove     = -0.120533

ACCEL #111 t=2.0144 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2440.667,0.000,2229.020) mag= 3305.356445
  WishDir    = (-0.824,0.000,0.567) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007783
  Dot(Vel,Wish) = -748.308350
  addSpeed = 930.308350
  accelSpeed(x10) = 2578.123714
  expectedAdd = 930.308350
  RETURN     = (2228.223,0.000,2375.084)
  DELTA      = (-212.444,0.000,146.065) mag= 257.812286
  CameraLook = (0.567,0.000,0.824) angle= 90.000000
  CameraRight= (-0.824,0.000,0.567) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.591,0.000,0.807) angle= 91.715812
  RootRight  = (-0.807,0.000,0.591) dot= 0.999552
  Wish(root basis): Right= 0.999552 Forward= -0.029942
  HumMove    = (-0.153,0.000,0.988) angle= 46.717372

AIRCONTROL #89 t=2.0144 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.824,0.000,0.567)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (2228.223,0.000,2375.084)
  Arg6 = 0.007783
  RETURN = (2228.223,0.000,2375.084)
  Arg4 vs CameraRight = -0.824024
  Arg4 vs RootRight   = -0.806691
  Arg4 vs CameraLook  = 0.566554
  Arg4 vs RootLook    = 0.590973
  Arg4 vs HumMove     = -0.152509

ACCEL #112 t=2.0229 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2228.223,0.000,2375.084) mag= 3256.685791
  WishDir    = (-0.859,0.000,0.511) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008269
  Dot(Vel,Wish) = -700.846680
  addSpeed = 882.846680
  accelSpeed(x10) = 2739.106500
  expectedAdd = 882.846680
  RETURN     = (1992.811,0.000,2515.114)
  DELTA      = (-235.412,0.000,140.029) mag= 273.910675
  CameraLook = (0.511,0.000,0.859) angle= 90.000002
  CameraRight= (-0.859,0.000,0.511) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.567,0.000,0.824) angle= 93.763457
  RootRight  = (-0.824,0.000,0.567) dot= 0.997844
  Wish(root basis): Right= 0.997844 Forward= -0.065637
  HumMove    = (-0.182,0.000,0.983) angle= 48.765007

AIRCONTROL #90 t=2.0230 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.859,0.000,0.511)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1992.811,0.000,2515.114)
  Arg6 = 0.008269
  RETURN = (1992.811,0.000,2515.114)
  Arg4 vs CameraRight = -0.859448
  Arg4 vs RootRight   = -0.824040
  Arg4 vs CameraLook  = 0.511222
  Arg4 vs RootLook    = 0.566532
  Arg4 vs HumMove     = -0.182059

ACCEL #113 t=2.0317 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1992.811,0.000,2515.114) mag= 3208.907959
  WishDir    = (-0.859,0.000,0.511) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008907
  Dot(Vel,Wish) = -426.936035
  addSpeed = 608.936035
  accelSpeed(x10) = 2950.368431
  expectedAdd = 608.936035
  RETURN     = (1739.242,0.000,2665.943)
  DELTA      = (-253.569,0.000,150.829) mag= 295.036804
  CameraLook = (0.511,0.000,0.859) angle= 90.000002
  CameraRight= (-0.859,0.000,0.511) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.511,0.000,0.859) angle= 89.998388
  RootRight  = (-0.859,0.000,0.511) dot= 1.000000
  Wish(root basis): Right= 1.000000 Forward= 0.000028
  HumMove    = (-0.246,0.000,0.969) angle= 44.999996

AIRCONTROL #91 t=2.0317 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.859,0.000,0.511)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1739.242,0.000,2665.943)
  Arg6 = 0.008907
  RETURN = (1739.242,0.000,2665.943)
  Arg4 vs CameraRight = -0.859448
  Arg4 vs RootRight   = -0.859463
  Arg4 vs CameraLook  = 0.511222
  Arg4 vs RootLook    = 0.511198
  Arg4 vs HumMove     = -0.246233

ACCEL #114 t=2.0393 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1739.242,0.000,2665.943) mag= 3183.113770
  WishDir    = (-0.881,0.000,0.473) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007759
  Dot(Vel,Wish) = -271.053223
  addSpeed = 453.053223
  accelSpeed(x10) = 2570.173894
  expectedAdd = 453.053223
  RETURN     = (1512.806,0.000,2787.536)
  DELTA      = (-226.435,0.000,121.593) mag= 257.017365
  CameraLook = (0.473,0.000,0.881) angle= 90.000000
  CameraRight= (-0.881,0.000,0.473) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.511,0.000,0.859) angle= 92.508235
  RootRight  = (-0.859,0.000,0.511) dot= 0.999042
  Wish(root basis): Right= 0.999042 Forward= -0.043763
  HumMove    = (-0.246,0.000,0.969) angle= 47.509994

AIRCONTROL #92 t=2.0394 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.881,0.000,0.473)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1512.806,0.000,2787.536)
  Arg6 = 0.007759
  RETURN = (1512.806,0.000,2787.536)
  Arg4 vs CameraRight = -0.881012
  Arg4 vs RootRight   = -0.859464
  Arg4 vs CameraLook  = 0.473093
  Arg4 vs RootLook    = 0.511196
  Arg4 vs HumMove     = -0.246233

ACCEL #115 t=2.0475 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1512.806,0.000,2787.536) mag= 3171.583252
  WishDir    = (-0.901,0.000,0.434) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008263
  Dot(Vel,Wish) = -152.917358
  addSpeed = 334.917358
  accelSpeed(x10) = 2737.118891
  expectedAdd = 334.917358
  RETURN     = (1266.223,0.000,2906.343)
  DELTA      = (-246.583,0.000,118.806) mag= 273.711884
  CameraLook = (0.434,0.000,0.901) angle= 90.000000
  CameraRight= (-0.901,0.000,0.434) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.473,0.000,0.881) angle= 92.508322
  RootRight  = (-0.881,0.000,0.473) dot= 0.999042
  Wish(root basis): Right= 0.999042 Forward= -0.043765
  HumMove    = (-0.288,0.000,0.957) angle= 47.510013

AIRCONTROL #93 t=2.0475 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.901,0.000,0.434)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1266.223,0.000,2906.343)
  Arg6 = 0.008263
  RETURN = (1266.223,0.000,2906.343)
  Arg4 vs CameraRight = -0.900886
  Arg4 vs RootRight   = -0.881026
  Arg4 vs CameraLook  = 0.434057
  Arg4 vs RootLook    = 0.473067
  Arg4 vs HumMove     = -0.288442

ACCEL #116 t=2.0558 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1266.223,0.000,2906.343) mag= 3170.196777
  WishDir    = (-0.920,0.000,0.391) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008342
  Dot(Vel,Wish) = -29.019775
  addSpeed = 211.019775
  accelSpeed(x10) = 2763.203989
  expectedAdd = 211.019775
  RETURN     = (1072.003,0.000,2988.853)
  DELTA      = (-194.220,0.000,82.510) mag= 211.019775
  CameraLook = (0.391,0.000,0.920) angle= 90.000000
  CameraRight= (-0.920,0.000,0.391) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.434,0.000,0.901) angle= 92.706437
  RootRight  = (-0.901,0.000,0.434) dot= 0.998885
  Wish(root basis): Right= 0.998885 Forward= -0.047219
  HumMove    = (-0.330,0.000,0.944) angle= 47.708164

AIRCONTROL #94 t=2.0559 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.920,0.000,0.391)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (1072.003,0.000,2988.853)
  Arg6 = 0.008342
  RETURN = (1072.003,0.000,2988.853)
  Arg4 vs CameraRight = -0.920388
  Arg4 vs RootRight   = -0.900899
  Arg4 vs CameraLook  = 0.391006
  Arg4 vs RootLook    = 0.434029
  Arg4 vs HumMove     = -0.330098

ACCEL #117 t=2.0646 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1072.003,0.000,2988.853) mag= 3175.284424
  WishDir    = (-0.936,0.000,0.351) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008895
  Dot(Vel,Wish) = 46.656372
  addSpeed = 135.343628
  accelSpeed(x10) = 2946.531724
  expectedAdd = 135.343628
  RETURN     = (945.291,0.000,3036.413)
  DELTA      = (-126.712,0.000,47.560) mag= 135.343582
  CameraLook = (0.351,0.000,0.936) angle= 90.000000
  CameraRight= (-0.936,0.000,0.351) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.391,0.000,0.920) angle= 92.442449
  RootRight  = (-0.920,0.000,0.391) dot= 0.999092
  Wish(root basis): Right= 0.999092 Forward= -0.042616
  HumMove    = (-0.374,0.000,0.927) angle= 47.443950

AIRCONTROL #95 t=2.0647 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.936,0.000,0.351)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (945.291,0.000,3036.413)
  Arg6 = 0.008895
  RETURN = (945.291,0.000,3036.413)
  Arg4 vs CameraRight = -0.936224
  Arg4 vs RootRight   = -0.920398
  Arg4 vs CameraLook  = 0.351403
  Arg4 vs RootLook    = 0.390982
  Arg4 vs HumMove     = -0.374330

ACCEL #118 t=2.0727 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (945.291,0.000,3036.413) mag= 3180.153564
  WishDir    = (-0.949,0.000,0.317) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007839
  Dot(Vel,Wish) = 64.776672
  addSpeed = 117.223328
  accelSpeed(x10) = 2596.493753
  expectedAdd = 117.223328
  RETURN     = (834.099,0.000,3073.530)
  DELTA      = (-111.192,0.000,37.117) mag= 117.223366
  CameraLook = (0.317,0.000,0.949) angle= 90.000002
  CameraRight= (-0.949,0.000,0.317) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.351,0.000,0.936) angle= 92.112609
  RootRight  = (-0.936,0.000,0.351) dot= 0.999320
  Wish(root basis): Right= 0.999320 Forward= -0.036864
  HumMove    = (-0.414,0.000,0.910) angle= 47.113682

AIRCONTROL #96 t=2.0727 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.949,0.000,0.317)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (834.099,0.000,3073.530)
  Arg6 = 0.007839
  RETURN = (834.099,0.000,3073.530)
  Arg4 vs CameraRight = -0.948548
  Arg4 vs RootRight   = -0.936231
  Arg4 vs CameraLook  = 0.316634
  Arg4 vs RootLook    = 0.351385
  Arg4 vs HumMove     = -0.413531

ACCEL #119 t=2.0812 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (834.099,0.000,3073.530) mag= 3184.698730
  WishDir    = (-0.958,0.000,0.286) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008279
  Dot(Vel,Wish) = 79.290710
  addSpeed = 102.709290
  accelSpeed(x10) = 2742.404889
  expectedAdd = 102.709290
  RETURN     = (735.676,0.000,3102.890)
  DELTA      = (-98.424,0.000,29.360) mag= 102.709320
  CameraLook = (0.286,0.000,0.958) angle= 89.999998
  CameraRight= (-0.958,0.000,0.286) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.317,0.000,0.949) angle= 91.848643
  RootRight  = (-0.949,0.000,0.317) dot= 0.999480
  Wish(root basis): Right= 0.999480 Forward= -0.032259
  HumMove    = (-0.447,0.000,0.895) angle= 46.849478

AIRCONTROL #97 t=2.0813 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.958,0.000,0.286)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (735.676,0.000,3102.890)
  Arg6 = 0.008279
  RETURN = (735.676,0.000,3102.890)
  Arg4 vs CameraRight = -0.958273
  Arg4 vs RootRight   = -0.948552
  Arg4 vs CameraLook  = 0.285855
  Arg4 vs RootLook    = 0.316620
  Arg4 vs HumMove     = -0.446831

ACCEL #120 t=2.0898 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (735.676,0.000,3102.890) mag= 3188.909424
  WishDir    = (-0.966,0.000,0.258) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008884
  Dot(Vel,Wish) = 90.179443
  addSpeed = 91.820557
  accelSpeed(x10) = 2942.680828
  expectedAdd = 91.820557
  RETURN     = (646.967,0.000,3126.591)
  DELTA      = (-88.709,0.000,23.701) mag= 91.820572
  CameraLook = (0.258,0.000,0.966) angle= 89.999999
  CameraRight= (-0.966,0.000,0.258) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.286,0.000,0.958) angle= 91.650598
  RootRight  = (-0.958,0.000,0.286) dot= 0.999585
  Wish(root basis): Right= 0.999585 Forward= -0.028804
  HumMove    = (-0.475,0.000,0.880) angle= 46.651313

AIRCONTROL #98 t=2.0899 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.966,0.000,0.258)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (646.967,0.000,3126.591)
  Arg6 = 0.008884
  RETURN = (646.967,0.000,3126.591)
  Arg4 vs CameraRight = -0.966112
  Arg4 vs RootRight   = -0.958276
  Arg4 vs CameraLook  = 0.258122
  Arg4 vs RootLook    = 0.285843
  Arg4 vs HumMove     = -0.475471

ACCEL #121 t=2.0976 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (646.967,0.000,3126.591) mag= 3192.825439
  WishDir    = (-0.975,0.000,0.221) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007798
  Dot(Vel,Wish) = 60.627930
  addSpeed = 121.372070
  accelSpeed(x10) = 2583.078547
  expectedAdd = 121.372070
  RETURN     = (528.601,0.000,3153.437)
  DELTA      = (-118.366,0.000,26.846) mag= 121.372063
  CameraLook = (0.221,0.000,0.975) angle= 90.000001
  CameraRight= (-0.975,0.000,0.221) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.258,0.000,0.966) angle= 92.179126
  RootRight  = (-0.966,0.000,0.258) dot= 0.999277
  Wish(root basis): Right= 0.999277 Forward= -0.038024
  HumMove    = (-0.501,0.000,0.866) angle= 47.179743

AIRCONTROL #99 t=2.0976 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.975,0.000,0.221)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (528.601,0.000,3153.437)
  Arg6 = 0.007798
  RETURN = (528.601,0.000,3153.437)
  Arg4 vs CameraRight = -0.975231
  Arg4 vs RootRight   = -0.966115
  Arg4 vs CameraLook  = 0.221190
  Arg4 vs RootLook    = 0.258112
  Arg4 vs HumMove     = -0.500625

ACCEL #122 t=2.1059 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (528.601,0.000,3153.437) mag= 3197.433594
  WishDir    = (-0.983,0.000,0.182) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008318
  Dot(Vel,Wish) = 53.081238
  addSpeed = 128.918762
  accelSpeed(x10) = 2755.144037
  expectedAdd = 128.918762
  RETURN     = (401.827,0.000,3176.857)
  DELTA      = (-126.773,0.000,23.421) mag= 128.918762
  CameraLook = (0.182,0.000,0.983) angle= 90.000000
  CameraRight= (-0.983,0.000,0.182) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.221,0.000,0.975) angle= 92.311117
  RootRight  = (-0.975,0.000,0.221) dot= 0.999187
  Wish(root basis): Right= 0.999187 Forward= -0.040326
  HumMove    = (-0.533,0.000,0.846) angle= 47.311854

AIRCONTROL #100 t=2.1060 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.983,0.000,0.182)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (401.827,0.000,3176.857)
  Arg6 = 0.008318
  RETURN = (401.827,0.000,3176.857)
  Arg4 vs CameraRight = -0.983360
  Arg4 vs RootRight   = -0.975234
  Arg4 vs CameraLook  = 0.181670
  Arg4 vs RootLook    = 0.221177
  Arg4 vs HumMove     = -0.533188

ACCEL #123 t=2.1146 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (401.827,0.000,3176.857) mag= 3202.169189
  WishDir    = (-0.987,0.000,0.162) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008827
  Dot(Vel,Wish) = 119.313629
  addSpeed = 62.686371
  accelSpeed(x10) = 2923.731133
  expectedAdd = 62.686371
  RETURN     = (339.973,0.000,3187.035)
  DELTA      = (-61.855,0.000,10.178) mag= 62.686367
  CameraLook = (0.162,0.000,0.987) angle= 90.000000
  CameraRight= (-0.987,0.000,0.162) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.182,0.000,0.983) angle= 91.122090
  RootRight  = (-0.983,0.000,0.182) dot= 0.999808
  Wish(root basis): Right= 0.999808 Forward= -0.019583
  HumMove    = (-0.567,0.000,0.824) angle= 46.122898

AIRCONTROL #101 t=2.1146 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.987,0.000,0.162)
  Arg3 = 1619.999903
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (339.973,0.000,3187.035)
  Arg6 = 0.008827
  RETURN = (339.973,0.000,3187.035)
  Arg4 vs CameraRight = -0.986731
  Arg4 vs RootRight   = -0.983362
  Arg4 vs CameraLook  = 0.162365
  Arg4 vs RootLook    = 0.181657
  Arg4 vs HumMove     = -0.566880

ACCEL #124 t=2.1230 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (339.973,0.000,3187.035) mag= 3205.117432
  WishDir    = (-0.990,0.000,0.142) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008355
  Dot(Vel,Wish) = 115.563507
  addSpeed = 66.436493
  accelSpeed(x10) = 2767.510219
  expectedAdd = 66.436493
  RETURN     = (274.208,0.000,3196.460)
  DELTA      = (-65.765,0.000,9.424) mag= 66.436485
  CameraLook = (0.142,0.000,0.990) angle= 89.999999
  CameraRight= (-0.990,0.000,0.142) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.162,0.000,0.987) angle= 91.188437
  RootRight  = (-0.987,0.000,0.162) dot= 0.999785
  Wish(root basis): Right= 0.999785 Forward= -0.020741
  HumMove    = (-0.583,0.000,0.813) angle= 46.188948

AIRCONTROL #102 t=2.1230 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.990,0.000,0.142)
  Arg3 = 1619.999903
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (274.208,0.000,3196.460)
  Arg6 = 0.008355
  RETURN = (274.208,0.000,3196.460)
  Arg4 vs CameraRight = -0.989887
  Arg4 vs RootRight   = -0.986732
  Arg4 vs CameraLook  = 0.141855
  Arg4 vs RootLook    = 0.162356
  Arg4 vs HumMove     = -0.582915

ACCEL #125 t=2.1309 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (274.208,0.000,3196.460) mag= 3208.199707
  WishDir    = (-0.993,0.000,0.116) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007865
  Dot(Vel,Wish) = 97.016724
  addSpeed = 84.983276
  accelSpeed(x10) = 2605.147243
  expectedAdd = 84.983276
  RETURN     = (189.794,0.000,3206.281)
  DELTA      = (-84.414,0.000,9.821) mag= 84.983269
  CameraLook = (0.116,0.000,0.993) angle= 90.000000
  CameraRight= (-0.993,0.000,0.116) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.142,0.000,0.990) angle= 91.518782
  RootRight  = (-0.990,0.000,0.142) dot= 0.999649
  Wish(root basis): Right= 0.999649 Forward= -0.026505
  HumMove    = (-0.600,0.000,0.800) angle= 46.519212

AIRCONTROL #103 t=2.1310 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.993,0.000,0.116)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (189.794,0.000,3206.281)
  Arg6 = 0.007865
  RETURN = (189.794,0.000,3206.281)
  Arg4 vs CameraRight = -0.993300
  Arg4 vs RootRight   = -0.989889
  Arg4 vs CameraLook  = 0.115562
  Arg4 vs RootLook    = 0.141848
  Arg4 vs HumMove     = -0.599649

ACCEL #126 t=2.1396 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (189.794,0.000,3206.281) mag= 3211.893066
  WishDir    = (-0.996,0.000,0.088) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008860
  Dot(Vel,Wish) = 93.217026
  addSpeed = 88.782974
  accelSpeed(x10) = 2934.772653
  expectedAdd = 88.782974
  RETURN     = (101.356,0.000,3214.097)
  DELTA      = (-88.438,0.000,7.816) mag= 88.782967
  CameraLook = (0.088,0.000,0.996) angle= 90.000000
  CameraRight= (-0.996,0.000,0.088) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.116,0.000,0.993) angle= 91.584771
  RootRight  = (-0.993,0.000,0.116) dot= 0.999617
  Wish(root basis): Right= 0.999617 Forward= -0.027656
  HumMove    = (-0.621,0.000,0.784) angle= 46.585270

AIRCONTROL #104 t=2.1397 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.996,0.000,0.088)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (101.356,0.000,3214.097)
  Arg6 = 0.008860
  RETURN = (101.356,0.000,3214.097)
  Arg4 vs CameraRight = -0.996117
  Arg4 vs RootRight   = -0.993301
  Arg4 vs CameraLook  = 0.088038
  Arg4 vs RootLook    = 0.115553
  Arg4 vs HumMove     = -0.620655

ACCEL #127 t=2.1475 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (101.356,0.000,3214.097) mag= 3215.694336
  WishDir    = (-0.998,0.000,0.063) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007769
  Dot(Vel,Wish) = 100.522903
  addSpeed = 81.477097
  accelSpeed(x10) = 2573.320813
  expectedAdd = 81.477097
  RETURN     = (20.040,0.000,3219.209)
  DELTA      = (-81.317,0.000,5.113) mag= 81.477097
  CameraLook = (0.063,0.000,0.998) angle= 90.000000
  CameraRight= (-0.998,0.000,0.063) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.088,0.000,0.996) angle= 91.452629
  RootRight  = (-0.996,0.000,0.088) dot= 0.999679
  Wish(root basis): Right= 0.999679 Forward= -0.025350
  HumMove    = (-0.642,0.000,0.767) angle= 46.453162

AIRCONTROL #105 t=2.1476 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.998,0.000,0.063)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (20.040,0.000,3219.209)
  Arg6 = 0.007769
  RETURN = (20.040,0.000,3219.209)
  Arg4 vs CameraRight = -0.998029
  Arg4 vs RootRight   = -0.996118
  Arg4 vs CameraLook  = 0.062748
  Arg4 vs RootLook    = 0.088029
  Arg4 vs HumMove     = -0.642109

ACCEL #128 t=2.1558 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (20.040,0.000,3219.209) mag= 3219.271729
  WishDir    = (-0.999,0.000,0.036) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008312
  Dot(Vel,Wish) = 96.722755
  addSpeed = 85.277245
  accelSpeed(x10) = 2753.225529
  expectedAdd = 85.277245
  RETURN     = (-65.182,0.000,3222.302)
  DELTA      = (-85.221,0.000,3.093) mag= 85.277260
  CameraLook = (0.036,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,0.036) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.063,0.000,0.998) angle= 91.518691
  RootRight  = (-0.998,0.000,0.063) dot= 0.999649
  Wish(root basis): Right= 0.999649 Forward= -0.026503
  HumMove    = (-0.661,0.000,0.750) angle= 46.519212

AIRCONTROL #106 t=2.1559 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.999,0.000,0.036)
  Arg3 = 1619.999903
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-65.182,0.000,3222.302)
  Arg6 = 0.008312
  RETURN = (-65.182,0.000,3222.302)
  Arg4 vs CameraRight = -0.999342
  Arg4 vs RootRight   = -0.998030
  Arg4 vs CameraLook  = 0.036266
  Arg4 vs RootLook    = 0.062739
  Arg4 vs HumMove     = -0.661344

ACCEL #129 t=2.1646 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-65.182,0.000,3222.302) mag= 3222.961182
  WishDir    = (-1.000,0.000,0.011) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008864
  Dot(Vel,Wish) = 100.338326
  addSpeed = 81.661674
  accelSpeed(x10) = 2936.069859
  expectedAdd = 81.661674
  RETURN     = (-146.838,0.000,3223.193)
  DELTA      = (-81.657,0.000,0.891) mag= 81.661682
  CameraLook = (0.011,0.000,1.000) angle= 90.000000
  CameraRight= (-1.000,0.000,0.011) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.036,0.000,0.999) angle= 91.452639
  RootRight  = (-0.999,0.000,0.036) dot= 0.999679
  Wish(root basis): Right= 0.999679 Forward= -0.025351
  HumMove    = (-0.681,0.000,0.732) angle= 46.453162

AIRCONTROL #107 t=2.1647 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-1.000,0.000,0.011)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-146.838,0.000,3223.193)
  Arg6 = 0.008864
  RETURN = (-146.838,0.000,3223.193)
  Arg4 vs CameraRight = -0.999940
  Arg4 vs RootRight   = -0.999343
  Arg4 vs CameraLook  = 0.010912
  Arg4 vs RootLook    = 0.036257
  Arg4 vs HumMove     = -0.680997

ACCEL #130 t=2.1726 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-146.838,0.000,3223.193) mag= 3226.536133
  WishDir    = (-1.000,0.000,-0.012) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007844
  Dot(Vel,Wish) = 107.683029
  addSpeed = 74.316971
  accelSpeed(x10) = 2598.343159
  expectedAdd = 74.316971
  RETURN     = (-221.150,0.000,3222.291)
  DELTA      = (-74.311,0.000,-0.903) mag= 74.316971
  CameraLook = (-0.012,0.000,1.000) angle= 90.000000
  CameraRight= (-1.000,0.000,-0.012) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.011,0.000,1.000) angle= 91.320540
  RootRight  = (-1.000,0.000,0.011) dot= 0.999734
  Wish(root basis): Right= 0.999734 Forward= -0.023046
  HumMove    = (-0.699,0.000,0.715) angle= 46.321057

AIRCONTROL #108 t=2.1726 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-1.000,0.000,-0.012)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-221.150,0.000,3222.291)
  Arg6 = 0.007844
  RETURN = (-221.150,0.000,3222.291)
  Arg4 vs CameraRight = -0.999926
  Arg4 vs RootRight   = -0.999941
  Arg4 vs CameraLook  = -0.012145
  Arg4 vs RootLook    = 0.010903
  Arg4 vs HumMove     = -0.699349

ACCEL #131 t=2.1809 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-221.150,0.000,3222.291) mag= 3229.870361
  WishDir    = (-0.999,0.000,-0.033) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008321
  Dot(Vel,Wish) = 115.049080
  addSpeed = 66.950920
  accelSpeed(x10) = 2756.123805
  expectedAdd = 66.950920
  RETURN     = (-288.065,0.000,3220.089)
  DELTA      = (-66.915,0.000,-2.202) mag= 66.950920
  CameraLook = (-0.033,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,-0.033) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.012,0.000,1.000) angle= 91.188472
  RootRight  = (-1.000,0.000,-0.012) dot= 0.999785
  Wish(root basis): Right= 0.999785 Forward= -0.020741
  HumMove    = (-0.716,0.000,0.698) angle= 46.188944

AIRCONTROL #109 t=2.1809 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.999,0.000,-0.033)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-288.065,0.000,3220.089)
  Arg6 = 0.008321
  RETURN = (-288.065,0.000,3220.089)
  Arg4 vs CameraRight = -0.999459
  Arg4 vs RootRight   = -0.999926
  Arg4 vs CameraLook  = -0.032890
  Arg4 vs RootLook    = -0.012153
  Arg4 vs HumMove     = -0.715642

ACCEL #132 t=2.1892 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-288.065,0.000,3220.089) mag= 3232.947998
  WishDir    = (-0.998,0.000,-0.069) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008341
  Dot(Vel,Wish) = 66.552490
  addSpeed = 115.447510
  accelSpeed(x10) = 2762.914315
  expectedAdd = 115.447510
  RETURN     = (-403.240,0.000,3212.171)
  DELTA      = (-115.176,0.000,-7.917) mag= 115.447533
  CameraLook = (-0.069,0.000,0.998) angle= 90.000000
  CameraRight= (-0.998,0.000,-0.069) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.033,0.000,0.999) angle= 92.047226
  RootRight  = (-0.999,0.000,-0.033) dot= 0.999362
  Wish(root basis): Right= 0.999362 Forward= -0.035723
  HumMove    = (-0.730,0.000,0.683) angle= 47.047633

AIRCONTROL #110 t=2.1893 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.998,0.000,-0.069)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-403.240,0.000,3212.171)
  Arg6 = 0.008341
  RETURN = (-403.240,0.000,3212.171)
  Arg4 vs CameraRight = -0.997646
  Arg4 vs RootRight   = -0.999459
  Arg4 vs CameraLook  = -0.068580
  Arg4 vs RootLook    = -0.032897
  Arg4 vs HumMove     = -0.729981

ACCEL #133 t=2.1979 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-403.240,0.000,3212.171) mag= 3237.382568
  WishDir    = (-0.995,0.000,-0.102) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008816
  Dot(Vel,Wish) = 73.856659
  addSpeed = 108.143341
  accelSpeed(x10) = 2920.322304
  expectedAdd = 108.143341
  RETURN     = (-510.821,0.000,3201.153)
  DELTA      = (-107.581,0.000,-11.019) mag= 108.143356
  CameraLook = (-0.102,0.000,0.995) angle= 90.000000
  CameraRight= (-0.995,0.000,-0.102) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (-0.069,0.000,0.998) angle= 91.914929
  RootRight  = (-0.998,0.000,-0.069) dot= 0.999442
  Wish(root basis): Right= 0.999442 Forward= -0.033416
  HumMove    = (-0.754,0.000,0.657) angle= 46.915515

AIRCONTROL #111 t=2.1980 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.995,0.000,-0.102)
  Arg3 = 1619.999903
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-510.821,0.000,3201.153)
  Arg6 = 0.008816
  RETURN = (-510.821,0.000,3201.153)
  Arg4 vs CameraRight = -0.994796
  Arg4 vs RootRight   = -0.997645
  Arg4 vs CameraLook  = -0.101889
  Arg4 vs RootLook    = -0.068590
  Arg4 vs HumMove     = -0.753936

ACCEL #134 t=2.2059 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-510.821,0.000,3201.153) mag= 3241.653320
  WishDir    = (-0.992,0.000,-0.125) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007885
  Dot(Vel,Wish) = 107.334198
  addSpeed = 74.665802
  accelSpeed(x10) = 2611.951635
  expectedAdd = 74.665802
  RETURN     = (-584.903,0.000,3191.834)
  DELTA      = (-74.082,0.000,-9.318) mag= 74.665810
  CameraLook = (-0.125,0.000,0.992) angle= 90.000000
  CameraRight= (-0.992,0.000,-0.125) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.102,0.000,0.995) angle= 91.320411
  RootRight  = (-0.995,0.000,-0.102) dot= 0.999734
  Wish(root basis): Right= 0.999734 Forward= -0.023043
  HumMove    = (-0.775,0.000,0.631) angle= 46.321047

AIRCONTROL #112 t=2.2060 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.992,0.000,-0.125)
  Arg3 = 1619.999903
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-584.903,0.000,3191.834)
  Arg6 = 0.007885
  RETURN = (-584.903,0.000,3191.834)
  Arg4 vs CameraRight = -0.992182
  Arg4 vs RootRight   = -0.994795
  Arg4 vs CameraLook  = -0.124797
  Arg4 vs RootLook    = -0.101900
  Arg4 vs HumMove     = -0.775473

ACCEL #135 t=2.2142 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-584.903,0.000,3191.834) mag= 3244.983643
  WishDir    = (-0.989,0.000,-0.149) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008266
  Dot(Vel,Wish) = 103.518555
  addSpeed = 78.481445
  accelSpeed(x10) = 2737.933308
  expectedAdd = 78.481445
  RETURN     = (-662.511,0.000,3180.158)
  DELTA      = (-77.608,0.000,-11.676) mag= 78.481415
  CameraLook = (-0.149,0.000,0.989) angle= 90.000000
  CameraRight= (-0.989,0.000,-0.149) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.125,0.000,0.992) angle= 91.386599
  RootRight  = (-0.992,0.000,-0.125) dot= 0.999707
  Wish(root basis): Right= 0.999707 Forward= -0.024198
  HumMove    = (-0.790,0.000,0.613) angle= 46.387096

AIRCONTROL #113 t=2.2142 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.989,0.000,-0.149)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-662.511,0.000,3180.158)
  Arg6 = 0.008266
  RETURN = (-662.511,0.000,3180.158)
  Arg4 vs CameraRight = -0.988871
  Arg4 vs RootRight   = -0.992181
  Arg4 vs CameraLook  = -0.148778
  Arg4 vs RootLook    = -0.124805
  Arg4 vs HumMove     = -0.789824

ACCEL #136 t=2.2227 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-662.511,0.000,3180.158) mag= 3248.434570
  WishDir    = (-0.981,0.000,-0.195) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008339
  Dot(Vel,Wish) = 28.552917
  addSpeed = 153.447083
  accelSpeed(x10) = 2762.293322
  expectedAdd = 153.447083
  RETURN     = (-813.002,0.000,3150.185)
  DELTA      = (-150.491,0.000,-29.974) mag= 153.447067
  CameraLook = (-0.195,0.000,0.981) angle= 90.000000
  CameraRight= (-0.981,0.000,-0.195) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.149,0.000,0.989) angle= 92.707689
  RootRight  = (-0.989,0.000,-0.149) dot= 0.998884
  Wish(root basis): Right= 0.998884 Forward= -0.047240
  HumMove    = (-0.804,0.000,0.594) angle= 47.708164

AIRCONTROL #114 t=2.2227 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.981,0.000,-0.195)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-813.002,0.000,3150.185)
  Arg6 = 0.008339
  RETURN = (-813.002,0.000,3150.185)
  Arg4 vs CameraRight = -0.980737
  Arg4 vs RootRight   = -0.988869
  Arg4 vs CameraLook  = -0.195335
  Arg4 vs RootLook    = -0.148786
  Arg4 vs HumMove     = -0.804439

ACCEL #137 t=2.2313 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-813.002,0.000,3150.185) mag= 3253.403809
  WishDir    = (-0.981,0.000,-0.195) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008921
  Dot(Vel,Wish) = 181.999939
  addSpeed = 0.000061
  accelSpeed(x10) = 2954.867776
  expectedAdd = 0.000061
  RETURN     = (-813.002,0.000,3150.185)
  DELTA      = (-0.000,0.000,0.000) mag= 0.000061
  CameraLook = (-0.195,0.000,0.981) angle= 90.000000
  CameraRight= (-0.981,0.000,-0.195) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.195,0.000,0.981) angle= 89.999180
  RootRight  = (-0.981,0.000,-0.195) dot= 1.000000
  Wish(root basis): Right= 1.000000 Forward= 0.000014
  HumMove    = (-0.832,0.000,0.555) angle= 45.000001

AIRCONTROL #115 t=2.2313 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.981,0.000,-0.195)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-813.002,0.000,3150.185)
  Arg6 = 0.008921
  RETURN = (-813.002,0.000,3150.185)
  Arg4 vs CameraRight = -0.980737
  Arg4 vs RootRight   = -0.980734
  Arg4 vs CameraLook  = -0.195335
  Arg4 vs RootLook    = -0.195349
  Arg4 vs HumMove     = -0.831608

ACCEL #138 t=2.2393 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-813.002,0.000,3150.185) mag= 3253.403809
  WishDir    = (-0.976,0.000,-0.218) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007828
  Dot(Vel,Wish) = 107.062866
  addSpeed = 74.937134
  accelSpeed(x10) = 2592.988058
  expectedAdd = 74.937134
  RETURN     = (-886.139,0.000,3133.856)
  DELTA      = (-73.137,0.000,-16.328) mag= 74.937157
  CameraLook = (-0.218,0.000,0.976) angle= 90.000001
  CameraRight= (-0.976,0.000,-0.218) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (-0.195,0.000,0.981) angle= 91.320819
  RootRight  = (-0.981,0.000,-0.195) dot= 0.999734
  Wish(root basis): Right= 0.999734 Forward= -0.023051
  HumMove    = (-0.832,0.000,0.555) angle= 46.321057

AIRCONTROL #116 t=2.2394 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.976,0.000,-0.218)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-886.139,0.000,3133.856)
  Arg6 = 0.007828
  RETURN = (-886.139,0.000,3133.856)
  Arg4 vs CameraRight = -0.975973
  Arg4 vs RootRight   = -0.980736
  Arg4 vs CameraLook  = -0.217894
  Arg4 vs RootLook    = -0.195339
  Arg4 vs HumMove     = -0.831608

ACCEL #139 t=2.2476 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-886.139,0.000,3133.856) mag= 3256.730957
  WishDir    = (-0.970,0.000,-0.241) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008268
  Dot(Vel,Wish) = 103.233704
  addSpeed = 78.766296
  accelSpeed(x10) = 2738.706078
  expectedAdd = 78.766296
  RETURN     = (-962.575,0.000,3114.838)
  DELTA      = (-76.436,0.000,-19.019) mag= 78.766281
  CameraLook = (-0.241,0.000,0.970) angle= 90.000000
  CameraRight= (-0.970,0.000,-0.241) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.218,0.000,0.976) angle= 91.386714
  RootRight  = (-0.976,0.000,-0.218) dot= 0.999707
  Wish(root basis): Right= 0.999707 Forward= -0.024200
  HumMove    = (-0.844,0.000,0.536) angle= 46.387106

AIRCONTROL #117 t=2.2476 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.970,0.000,-0.241)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-962.575,0.000,3114.838)
  Arg6 = 0.008268
  RETURN = (-962.575,0.000,3114.838)
  Arg4 vs CameraRight = -0.970412
  Arg4 vs RootRight   = -0.975971
  Arg4 vs CameraLook  = -0.241455
  Arg4 vs RootLook    = -0.217900
  Arg4 vs HumMove     = -0.844191

ACCEL #140 t=2.2559 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-962.575,0.000,3114.838) mag= 3260.178467
  WishDir    = (-0.964,0.000,-0.266) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008409
  Dot(Vel,Wish) = 99.393005
  addSpeed = 82.606995
  accelSpeed(x10) = 2785.548938
  expectedAdd = 82.606995
  RETURN     = (-1042.206,0.000,3092.865)
  DELTA      = (-79.631,0.000,-21.972) mag= 82.606956
  CameraLook = (-0.266,0.000,0.964) angle= 90.000000
  CameraRight= (-0.964,0.000,-0.266) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.241,0.000,0.970) angle= 91.452735
  RootRight  = (-0.970,0.000,-0.241) dot= 0.999679
  Wish(root basis): Right= 0.999679 Forward= -0.025352
  HumMove    = (-0.857,0.000,0.515) angle= 46.453162

AIRCONTROL #118 t=2.2560 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.964,0.000,-0.266)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-1042.206,0.000,3092.865)
  Arg6 = 0.008409
  RETURN = (-1042.206,0.000,3092.865)
  Arg4 vs CameraRight = -0.963977
  Arg4 vs RootRight   = -0.970410
  Arg4 vs CameraLook  = -0.265987
  Arg4 vs RootLook    = -0.241462
  Arg4 vs HumMove     = -0.856920

ACCEL #141 t=2.2643 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-1042.206,0.000,3092.865) mag= 3263.741455
  WishDir    = (-0.960,0.000,-0.282) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008257
  Dot(Vel,Wish) = 129.384583
  addSpeed = 52.615417
  accelSpeed(x10) = 2735.159046
  expectedAdd = 52.615417
  RETURN     = (-1092.693,0.000,3078.053)
  DELTA      = (-50.488,0.000,-14.812) mag= 52.615406
  CameraLook = (-0.282,0.000,0.960) angle= 90.000002
  CameraRight= (-0.960,0.000,-0.282) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (-0.266,0.000,0.964) angle= 90.924272
  RootRight  = (-0.964,0.000,-0.266) dot= 0.999870
  Wish(root basis): Right= 0.999870 Forward= -0.016131
  HumMove    = (-0.870,0.000,0.494) angle= 45.924735

AIRCONTROL #119 t=2.2644 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.960,0.000,-0.282)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-1092.693,0.000,3078.053)
  Arg6 = 0.008257
  RETURN = (-1092.693,0.000,3078.053)
  Arg4 vs CameraRight = -0.959558
  Arg4 vs RootRight   = -0.963974
  Arg4 vs CameraLook  = -0.281510
  Arg4 vs RootLook    = -0.265995
  Arg4 vs HumMove     = -0.869716

ACCEL #142 t=2.2725 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-1092.693,0.000,3078.053) mag= 3266.250488
  WishDir    = (-0.955,0.000,-0.298) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008327
  Dot(Vel,Wish) = 125.581665
  addSpeed = 56.418335
  accelSpeed(x10) = 2758.387206
  expectedAdd = 56.418335
  RETURN     = (-1146.547,0.000,3061.237)
  DELTA      = (-53.854,0.000,-16.816) mag= 56.418407
  CameraLook = (-0.298,0.000,0.955) angle= 90.000000
  CameraRight= (-0.955,0.000,-0.298) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.282,0.000,0.960) angle= 90.990434
  RootRight  = (-0.960,0.000,-0.282) dot= 0.999851
  Wish(root basis): Right= 0.999851 Forward= -0.017285
  HumMove    = (-0.878,0.000,0.479) angle= 45.990787

AIRCONTROL #120 t=2.2726 state=Enum.HumanoidStateType.Freefall callerLine=474
  callerSource = =Opiumware
  Arg2 = (-0.955,0.000,-0.298)
  Arg3 = 1620.000000
  Arg4 = (1.000,0.000,-0.000)
  Arg5 = (-1146.547,0.000,3061.237)
  Arg6 = 0.008327
  RETURN = (-1146.547,0.000,3061.237)
  Arg4 vs CameraRight = -0.954547
  Arg4 vs RootRight   = -0.959557
  Arg4 vs CameraLook  = -0.298060
  Arg4 vs RootLook    = -0.281516
  Arg4 vs HumMove     = -0.877568

ACCEL #143 t=2.2808 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-1146.547,0.000,3061.237) mag= 3268.905762
  WishDir    = (-0.950,0.000,-0.313) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008369
  Dot(Vel,Wish) = 129.301208
  addSpeed = 52.698792
  accelSpeed(x10) = 2772.009564
  expectedAdd = 52.698792
  RETURN     = (-1196.591,0.000,3044.720)
  DELTA      = (-50.043,0.000,-16.517) mag= 52.698860
  CameraLook = (-0.313,0.000,0.950) angle= 90.000000
  CameraRight= (-0.950,0.000,-0.313) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.298,0.000,0.955) angle= 90.924414
  RootRight  = (-0.955,0.000,-0.298) dot= 0.999870
  Wish(root basis): Right= 0.999870 Forward= -0.016133
  HumMove    = (-0.886,0.000,0.464) angle= 45.924735

ACCEL #144 t=2.2892 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-1196.591,0.000,3044.720) mag= 3271.413818
  WishDir    = (-0.946,0.000,-0.324) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008342
  Dot(Vel,Wish) = 144.332764
  addSpeed = 37.667236
  accelSpeed(x10) = 2763.066093
  expectedAdd = 37.667236
  RETURN     = (-1232.221,0.000,3032.502)
  DELTA      = (-35.631,0.000,-12.218) mag= 37.667194
  CameraLook = (-0.324,0.000,0.946) angle= 90.000002
  CameraRight= (-0.946,0.000,-0.324) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (-0.313,0.000,0.950) angle= 90.660231
  RootRight  = (-0.950,0.000,-0.313) dot= 0.999934
  Wish(root basis): Right= 0.999934 Forward= -0.011523
  HumMove    = (-0.893,0.000,0.450) angle= 45.660535

ACCEL #145 t=2.3066 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-1232.221,0.000,3032.502) mag= 3273.291992
  WishDir    = (0.945,0.000,0.328) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.009103
  Dot(Vel,Wish) = -170.695801
  addSpeed = 352.695801
  accelSpeed(x10) = 3015.263892
  expectedAdd = 352.695801
  RETURN     = (-947.337,0.000,3131.290)
  DELTA      = (284.885,0.000,98.787) mag= 301.526428
  CameraLook = (-0.328,0.000,0.945) angle= 90.000000
  CameraRight= (-0.945,0.000,-0.328) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.328,0.000,0.945) angle= 90.000041
  RootRight  = (-0.945,0.000,-0.328) dot= -1.000000
  Wish(root basis): Right= -1.000000 Forward= -0.000001
  HumMove    = (0.436,0.000,0.900) angle= 44.999996

ACCEL #146 t=2.3146 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-947.337,0.000,3131.290) mag= 3271.455566
  WishDir    = (0.945,0.000,0.328) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008159
  Dot(Vel,Wish) = 130.830627
  addSpeed = 51.169373
  accelSpeed(x10) = 2702.711315
  expectedAdd = 51.169373
  RETURN     = (-898.991,0.000,3148.054)
  DELTA      = (48.345,0.000,16.764) mag= 51.169353
  CameraLook = (-0.328,0.000,0.945) angle= 90.000000
  CameraRight= (-0.945,0.000,-0.328) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.328,0.000,0.945) angle= 89.998572
  RootRight  = (-0.945,0.000,-0.328) dot= -1.000000
  Wish(root basis): Right= -1.000000 Forward= 0.000025
  HumMove    = (0.436,0.000,0.900) angle= 44.999996

ACCEL #147 t=2.3229 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-898.991,0.000,3148.054) mag= 3273.901123
  WishDir    = (0.945,0.000,0.328) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008383
  Dot(Vel,Wish) = 182.000061
  addSpeed = -0.000061
  accelSpeed(x10) = 2776.729789
  expectedAdd = 0.000000
  RETURN     = (-898.991,0.000,3148.054)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (-0.328,0.000,0.945) angle= 90.000000
  CameraRight= (-0.945,0.000,-0.328) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.328,0.000,0.945) angle= 89.999192
  RootRight  = (-0.945,0.000,-0.328) dot= -1.000000
  Wish(root basis): Right= -1.000000 Forward= 0.000014
  HumMove    = (0.436,0.000,0.900) angle= 44.999996

ACCEL #148 t=2.3308 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-898.991,0.000,3148.054) mag= 3273.901123
  WishDir    = (0.945,0.000,0.328) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007824
  Dot(Vel,Wish) = 182.000061
  addSpeed = -0.000061
  accelSpeed(x10) = 2591.663088
  expectedAdd = 0.000000
  RETURN     = (-898.991,0.000,3148.054)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (-0.328,0.000,0.945) angle= 90.000000
  CameraRight= (-0.945,0.000,-0.328) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.328,0.000,0.945) angle= 89.999513
  RootRight  = (-0.945,0.000,-0.328) dot= -1.000000
  Wish(root basis): Right= -1.000000 Forward= 0.000008
  HumMove    = (0.436,0.000,0.900) angle= 44.999996

ACCEL #149 t=2.3393 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-898.991,0.000,3148.054) mag= 3273.901123
  WishDir    = (0.947,0.000,0.322) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008206
  Dot(Vel,Wish) = 163.154785
  addSpeed = 18.845215
  accelSpeed(x10) = 2718.127858
  expectedAdd = 18.845215
  RETURN     = (-881.151,0.000,3154.125)
  DELTA      = (17.840,0.000,6.071) mag= 18.845163
  CameraLook = (-0.322,0.000,0.947) angle= 90.000002
  CameraRight= (-0.947,0.000,-0.322) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (-0.328,0.000,0.945) angle= 90.330168
  RootRight  = (-0.945,0.000,-0.328) dot= -0.999983
  Wish(root basis): Right= -0.999983 Forward= -0.005762
  HumMove    = (0.436,0.000,0.900) angle= 45.330255

ACCEL #150 t=2.3475 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-881.151,0.000,3154.125) mag= 3274.894287
  WishDir    = (0.949,0.000,0.316) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008342
  Dot(Vel,Wish) = 159.378357
  addSpeed = 22.621643
  accelSpeed(x10) = 2763.079975
  expectedAdd = 22.621643
  RETURN     = (-859.686,0.000,3161.265)
  DELTA      = (21.465,0.000,7.140) mag= 22.621620
  CameraLook = (-0.316,0.000,0.949) angle= 90.000000
  CameraRight= (-0.949,0.000,-0.316) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.322,0.000,0.947) angle= 90.396062
  RootRight  = (-0.947,0.000,-0.322) dot= -0.999976
  Wish(root basis): Right= -0.999976 Forward= -0.006913
  HumMove    = (0.442,0.000,0.897) angle= 45.396309

ACCEL #151 t=2.3558 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-859.686,0.000,3161.265) mag= 3276.072754
  WishDir    = (0.954,0.000,0.301) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008300
  Dot(Vel,Wish) = 132.958618
  addSpeed = 49.041382
  accelSpeed(x10) = 2749.443735
  expectedAdd = 49.041382
  RETURN     = (-812.924,0.000,3176.044)
  DELTA      = (46.761,0.000,14.779) mag= 49.041370
  CameraLook = (-0.301,0.000,0.954) angle= 90.000002
  CameraRight= (-0.954,0.000,-0.301) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (-0.316,0.000,0.949) angle= 90.858408
  RootRight  = (-0.949,0.000,-0.316) dot= -0.999888
  Wish(root basis): Right= -0.999888 Forward= -0.014981
  HumMove    = (0.448,0.000,0.894) angle= 45.858685

ACCEL #152 t=2.3642 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-812.924,0.000,3176.044) mag= 3278.429443
  WishDir    = (0.958,0.000,0.286) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008433
  Dot(Vel,Wish) = 129.147156
  addSpeed = 52.852844
  accelSpeed(x10) = 2793.305643
  expectedAdd = 52.852844
  RETURN     = (-762.278,0.000,3191.156)
  DELTA      = (50.646,0.000,15.112) mag= 52.852848
  CameraLook = (-0.286,0.000,0.958) angle= 90.000000
  CameraRight= (-0.958,0.000,-0.286) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.301,0.000,0.954) angle= 90.924320
  RootRight  = (-0.954,0.000,-0.301) dot= -0.999870
  Wish(root basis): Right= -0.999870 Forward= -0.016132
  HumMove    = (0.461,0.000,0.887) angle= 45.924730

ACCEL #153 t=2.3726 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-762.278,0.000,3191.156) mag= 3280.936523
  WishDir    = (0.964,0.000,0.266) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008288
  Dot(Vel,Wish) = 113.987915
  addSpeed = 68.012085
  accelSpeed(x10) = 2745.468825
  expectedAdd = 68.012085
  RETURN     = (-696.716,0.000,3209.246)
  DELTA      = (65.562,0.000,18.090) mag= 68.012100
  CameraLook = (-0.266,0.000,0.964) angle= 90.000000
  CameraRight= (-0.964,0.000,-0.266) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.286,0.000,0.958) angle= 91.188477
  RootRight  = (-0.958,0.000,-0.286) dot= -0.999785
  Wish(root basis): Right= -0.999785 Forward= -0.020741
  HumMove    = (0.475,0.000,0.880) angle= 46.188944

ACCEL #154 t=2.3814 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-696.716,0.000,3209.246) mag= 3284.002930
  WishDir    = (0.973,0.000,0.230) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008869
  Dot(Vel,Wish) = 60.940369
  addSpeed = 121.059631
  accelSpeed(x10) = 2937.795251
  expectedAdd = 121.059631
  RETURN     = (-578.909,0.000,3237.121)
  DELTA      = (117.807,0.000,27.874) mag= 121.059639
  CameraLook = (-0.230,0.000,0.973) angle= 90.000001
  CameraRight= (-0.973,0.000,-0.230) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (-0.266,0.000,0.964) angle= 92.113130
  RootRight  = (-0.964,0.000,-0.266) dot= -0.999320
  Wish(root basis): Right= -0.999320 Forward= -0.036873
  HumMove    = (0.494,0.000,0.870) angle= 47.113686

ACCEL #155 t=2.3896 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-578.909,0.000,3237.121) mag= 3288.477783
  WishDir    = (0.982,0.000,0.190) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008020
  Dot(Vel,Wish) = 45.612427
  addSpeed = 136.387573
  accelSpeed(x10) = 2656.448110
  expectedAdd = 136.387573
  RETURN     = (-444.997,0.000,3262.990)
  DELTA      = (133.912,0.000,25.870) mag= 136.387589
  CameraLook = (-0.190,0.000,0.982) angle= 89.999999
  CameraRight= (-0.982,0.000,-0.190) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.230,0.000,0.973) angle= 92.377076
  RootRight  = (-0.973,0.000,-0.230) dot= -0.999140
  Wish(root basis): Right= -0.999140 Forward= -0.041476
  HumMove    = (0.525,0.000,0.851) angle= 47.377900

ACCEL #156 t=2.3975 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-444.997,0.000,3262.990) mag= 3293.194580
  WishDir    = (0.987,0.000,0.160) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008080
  Dot(Vel,Wish) = 83.374603
  addSpeed = 98.625397
  accelSpeed(x10) = 2676.350117
  expectedAdd = 98.625397
  RETURN     = (-347.645,0.000,3278.787)
  DELTA      = (97.352,0.000,15.797) mag= 98.625389
  CameraLook = (-0.160,0.000,0.987) angle= 90.000001
  CameraRight= (-0.987,0.000,-0.160) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (-0.190,0.000,0.982) angle= 91.716369
  RootRight  = (-0.982,0.000,-0.190) dot= -0.999551
  Wish(root basis): Right= -0.999551 Forward= -0.029952
  HumMove    = (0.560,0.000,0.828) angle= 46.717368

ACCEL #157 t=2.4058 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-347.645,0.000,3278.787) mag= 3297.165771
  WishDir    = (0.992,0.000,0.128) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008335
  Dot(Vel,Wish) = 75.654999
  addSpeed = 106.345001
  accelSpeed(x10) = 2760.844030
  expectedAdd = 106.345001
  RETURN     = (-242.178,0.000,3292.423)
  DELTA      = (105.467,0.000,13.636) mag= 106.344986
  CameraLook = (-0.128,0.000,0.992) angle= 90.000000
  CameraRight= (-0.992,0.000,-0.128) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.160,0.000,0.987) angle= 91.848606
  RootRight  = (-0.987,0.000,-0.160) dot= -0.999480
  Wish(root basis): Right= -0.999480 Forward= -0.032259
  HumMove    = (0.585,0.000,0.811) angle= 46.849474

ACCEL #158 t=2.4146 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-242.178,0.000,3292.423) mag= 3301.318115
  WishDir    = (0.994,0.000,0.110) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008918
  Dot(Vel,Wish) = 121.170685
  addSpeed = 60.829315
  accelSpeed(x10) = 2954.108887
  expectedAdd = 60.829315
  RETURN     = (-181.717,0.000,3299.109)
  DELTA      = (60.461,0.000,6.686) mag= 60.829319
  CameraLook = (-0.110,0.000,0.994) angle= 90.000000
  CameraRight= (-0.994,0.000,-0.110) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.128,0.000,0.992) angle= 91.055975
  RootRight  = (-0.992,0.000,-0.128) dot= -0.999830
  Wish(root basis): Right= -0.999830 Forward= -0.018429
  HumMove    = (0.611,0.000,0.792) angle= 46.056846

ACCEL #159 t=2.4234 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-181.717,0.000,3299.109) mag= 3304.110107
  WishDir    = (0.999,0.000,0.050) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008444
  Dot(Vel,Wish) = -15.981689
  addSpeed = 197.981689
  accelSpeed(x10) = 2796.962808
  expectedAdd = 197.981689
  RETURN     = (16.015,0.000,3309.042)
  DELTA      = (197.732,0.000,9.932) mag= 197.981705
  CameraLook = (-0.050,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,-0.050) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (-0.110,0.000,0.994) angle= 93.433789
  RootRight  = (-0.994,0.000,-0.110) dot= -0.998205
  Wish(root basis): Right= -0.998205 Forward= -0.059895
  HumMove    = (0.625,0.000,0.781) angle= 48.434747

ACCEL #160 t=2.4307 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (16.015,0.000,3309.042) mag= 3309.080322
  WishDir    = (0.999,0.000,0.050) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007649
  Dot(Vel,Wish) = 182.000000
  addSpeed = 0.000000
  accelSpeed(x10) = 2533.585747
  expectedAdd = 0.000000
  RETURN     = (16.015,0.000,3309.042)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (-0.050,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,-0.050) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (-0.050,0.000,0.999) angle= 90.000000
  RootRight  = (-0.999,0.000,-0.050) dot= -1.000000
  Wish(root basis): Right= -1.000000 Forward= 0.000000
  HumMove    = (0.671,0.000,0.742) angle= 44.999996

ACCEL #161 t=2.4392 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (16.015,0.000,3309.042) mag= 3309.080322
  WishDir    = (1.000,0.000,0.019) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008293
  Dot(Vel,Wish) = 79.083488
  addSpeed = 102.916512
  accelSpeed(x10) = 2746.973337
  expectedAdd = 102.916512
  RETURN     = (118.913,0.000,3311.003)
  DELTA      = (102.898,0.000,1.962) mag= 102.916512
  CameraLook = (-0.019,0.000,1.000) angle= 90.000000
  CameraRight= (-1.000,0.000,-0.019) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.050,0.000,0.999) angle= 91.782374
  RootRight  = (-0.999,0.000,-0.050) dot= -0.999516
  Wish(root basis): Right= -0.999516 Forward= -0.031103
  HumMove    = (0.671,0.000,0.742) angle= 46.783431

ACCEL #162 t=2.4481 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (118.913,0.000,3311.003) mag= 3313.137695
  WishDir    = (1.000,0.000,-0.011) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008911
  Dot(Vel,Wish) = 82.775681
  addSpeed = 99.224319
  accelSpeed(x10) = 2951.707283
  expectedAdd = 99.224319
  RETURN     = (218.131,0.000,3309.920)
  DELTA      = (99.218,0.000,-1.083) mag= 99.224327
  CameraLook = (0.011,0.000,1.000) angle= 90.000000
  CameraRight= (-1.000,0.000,0.011) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.019,0.000,1.000) angle= 91.716440
  RootRight  = (-1.000,0.000,-0.019) dot= -0.999551
  Wish(root basis): Right= -0.999551 Forward= -0.029953
  HumMove    = (0.694,0.000,0.720) angle= 46.717372

ACCEL #163 t=2.4560 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (218.131,0.000,3309.920) mag= 3317.100342
  WishDir    = (0.999,0.000,-0.039) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007851
  Dot(Vel,Wish) = 90.301979
  addSpeed = 91.698021
  accelSpeed(x10) = 2600.454782
  expectedAdd = 91.698021
  RETURN     = (309.761,0.000,3306.384)
  DELTA      = (91.630,0.000,-3.537) mag= 91.698029
  CameraLook = (0.039,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,0.039) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.011,0.000,1.000) angle= 91.584410
  RootRight  = (-1.000,0.000,0.011) dot= -0.999618
  Wish(root basis): Right= -0.999618 Forward= -0.027650
  HumMove    = (0.715,0.000,0.699) angle= 46.585266

ACCEL #164 t=2.4642 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (309.761,0.000,3306.384) mag= 3320.861816
  WishDir    = (0.998,0.000,-0.058) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008287
  Dot(Vel,Wish) = 116.983963
  addSpeed = 65.016037
  accelSpeed(x10) = 2745.054829
  expectedAdd = 65.016037
  RETURN     = (374.667,0.000,3302.603)
  DELTA      = (64.906,0.000,-3.781) mag= 65.016045
  CameraLook = (0.058,0.000,0.998) angle= 90.000000
  CameraRight= (-0.998,0.000,0.058) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.039,0.000,0.999) angle= 91.122084
  RootRight  = (-0.999,0.000,0.039) dot= -0.999808
  Wish(root basis): Right= -0.999808 Forward= -0.019583
  HumMove    = (0.734,0.000,0.679) angle= 46.122894

ACCEL #165 t=2.4726 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (374.667,0.000,3302.603) mag= 3323.787354
  WishDir    = (0.996,0.000,-0.088) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008349
  Dot(Vel,Wish) = 82.456238
  addSpeed = 99.543762
  accelSpeed(x10) = 2765.398596
  expectedAdd = 99.543762
  RETURN     = (473.824,0.000,3293.839)
  DELTA      = (99.157,0.000,-8.764) mag= 99.543777
  CameraLook = (0.088,0.000,0.996) angle= 90.000000
  CameraRight= (-0.996,0.000,0.088) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.058,0.000,0.998) angle= 91.716708
  RootRight  = (-0.998,0.000,0.058) dot= -0.999551
  Wish(root basis): Right= -0.999551 Forward= -0.029958
  HumMove    = (0.747,0.000,0.665) angle= 46.717372

ACCEL #166 t=2.4809 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (473.824,0.000,3293.839) mag= 3327.745117
  WishDir    = (0.992,0.000,-0.122) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008331
  Dot(Vel,Wish) = 66.995514
  addSpeed = 115.004486
  accelSpeed(x10) = 2759.615618
  expectedAdd = 115.004486
  RETURN     = (587.964,0.000,3279.759)
  DELTA      = (114.139,0.000,-14.080) mag= 115.004486
  CameraLook = (0.122,0.000,0.992) angle= 90.000000
  CameraRight= (-0.992,0.000,0.122) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.088,0.000,0.996) angle= 91.980813
  RootRight  = (-0.996,0.000,0.088) dot= -0.999403
  Wish(root basis): Right= -0.999403 Forward= -0.034565
  HumMove    = (0.767,0.000,0.642) angle= 46.981589

ACCEL #167 t=2.4897 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (587.964,0.000,3279.759) mag= 3332.044678
  WishDir    = (0.989,0.000,-0.149) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008862
  Dot(Vel,Wish) = 93.728241
  addSpeed = 88.271759
  accelSpeed(x10) = 2935.297089
  expectedAdd = 88.271759
  RETURN     = (675.254,0.000,3266.633)
  DELTA      = (87.290,0.000,-13.126) mag= 88.271774
  CameraLook = (0.149,0.000,0.989) angle= 90.000000
  CameraRight= (-0.989,0.000,0.149) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.122,0.000,0.992) angle= 91.518333
  RootRight  = (-0.992,0.000,0.122) dot= -0.999649
  Wish(root basis): Right= -0.999649 Forward= -0.026497
  HumMove    = (0.788,0.000,0.615) angle= 46.519212

ACCEL #168 t=2.4976 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (675.254,0.000,3266.633) mag= 3335.695068
  WishDir    = (0.985,0.000,-0.173) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007795
  Dot(Vel,Wish) = 101.318604
  addSpeed = 80.681396
  accelSpeed(x10) = 2582.029677
  expectedAdd = 80.681396
  RETURN     = (754.725,0.000,3252.708)
  DELTA      = (79.471,0.000,-13.925) mag= 80.681351
  CameraLook = (0.173,0.000,0.985) angle= 90.000001
  CameraRight= (-0.985,0.000,0.173) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (0.149,0.000,0.989) angle= 91.386317
  RootRight  = (-0.989,0.000,0.149) dot= -0.999707
  Wish(root basis): Right= -0.999707 Forward= -0.024193
  HumMove    = (0.804,0.000,0.594) angle= 46.387115

ACCEL #169 t=2.5059 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (754.725,0.000,3252.708) mag= 3339.119629
  WishDir    = (0.983,0.000,-0.185) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008368
  Dot(Vel,Wish) = 139.705139
  addSpeed = 42.294861
  accelSpeed(x10) = 2771.802566
  expectedAdd = 42.294861
  RETURN     = (796.289,0.000,3244.881)
  DELTA      = (41.564,0.000,-7.828) mag= 42.294861
  CameraLook = (0.185,0.000,0.983) angle= 90.000000
  CameraRight= (-0.983,0.000,0.185) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.173,0.000,0.985) angle= 90.725853
  RootRight  = (-0.985,0.000,0.173) dot= -0.999920
  Wish(root basis): Right= -0.999920 Forward= -0.012668
  HumMove    = (0.819,0.000,0.574) angle= 45.726578

ACCEL #170 t=2.5142 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (796.289,0.000,3244.881) mag= 3341.156494
  WishDir    = (0.979,0.000,-0.203) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008273
  Dot(Vel,Wish) = 120.434753
  addSpeed = 61.565247
  accelSpeed(x10) = 2740.445044
  expectedAdd = 61.565247
  RETURN     = (856.570,0.000,3232.373)
  DELTA      = (60.281,0.000,-12.508) mag= 61.565205
  CameraLook = (0.203,0.000,0.979) angle= 90.000000
  CameraRight= (-0.979,0.000,0.203) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.185,0.000,0.983) angle= 91.056318
  RootRight  = (-0.983,0.000,0.185) dot= -0.999830
  Wish(root basis): Right= -0.999830 Forward= -0.018435
  HumMove    = (0.826,0.000,0.564) angle= 46.056846

ACCEL #171 t=2.5230 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (856.570,0.000,3232.373) mag= 3343.941650
  WishDir    = (0.973,0.000,-0.229) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008917
  Dot(Vel,Wish) = 93.412415
  addSpeed = 88.587585
  accelSpeed(x10) = 2953.625790
  expectedAdd = 88.587585
  RETURN     = (942.802,0.000,3212.082)
  DELTA      = (86.232,0.000,-20.291) mag= 88.587616
  CameraLook = (0.229,0.000,0.973) angle= 89.999999
  CameraRight= (-0.973,0.000,0.229) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.203,0.000,0.979) angle= 91.518649
  RootRight  = (-0.979,0.000,0.203) dot= -0.999649
  Wish(root basis): Right= -0.999649 Forward= -0.026502
  HumMove    = (0.836,0.000,0.549) angle= 46.519212

ACCEL #172 t=2.5310 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (942.802,0.000,3212.082) mag= 3347.587891
  WishDir    = (0.965,0.000,-0.263) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007813
  Dot(Vel,Wish) = 66.308350
  addSpeed = 115.691650
  accelSpeed(x10) = 2588.116055
  expectedAdd = 115.691650
  RETURN     = (1054.435,0.000,3181.704)
  DELTA      = (111.632,0.000,-30.378) mag= 115.691628
  CameraLook = (0.263,0.000,0.965) angle= 90.000000
  CameraRight= (-0.965,0.000,0.263) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.229,0.000,0.973) angle= 91.980900
  RootRight  = (-0.973,0.000,0.229) dot= -0.999402
  Wish(root basis): Right= -0.999402 Forward= -0.034566
  HumMove    = (0.850,0.000,0.526) angle= 46.981589

ACCEL #173 t=2.5393 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1054.435,0.000,3181.704) mag= 3351.875977
  WishDir    = (0.954,0.000,-0.301) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008290
  Dot(Vel,Wish) = 46.842346
  addSpeed = 135.157654
  accelSpeed(x10) = 2746.117582
  expectedAdd = 135.157654
  RETURN     = (1183.312,0.000,3140.983)
  DELTA      = (128.877,0.000,-40.721) mag= 135.157654
  CameraLook = (0.301,0.000,0.954) angle= 90.000000
  CameraRight= (-0.954,0.000,0.301) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.263,0.000,0.965) angle= 92.310976
  RootRight  = (-0.965,0.000,0.263) dot= -0.999187
  Wish(root basis): Right= -0.999187 Forward= -0.040323
  HumMove    = (0.868,0.000,0.497) angle= 47.311845

ACCEL #174 t=2.5475 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1183.312,0.000,3140.983) mag= 3356.486572
  WishDir    = (0.945,0.000,-0.328) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008361
  Dot(Vel,Wish) = 89.211548
  addSpeed = 92.788452
  accelSpeed(x10) = 2769.345742
  expectedAdd = 92.788452
  RETURN     = (1270.982,0.000,3110.590)
  DELTA      = (87.670,0.000,-30.393) mag= 92.788368
  CameraLook = (0.328,0.000,0.945) angle= 90.000000
  CameraRight= (-0.945,0.000,0.328) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.301,0.000,0.954) angle= 91.584282
  RootRight  = (-0.954,0.000,0.301) dot= -0.999618
  Wish(root basis): Right= -0.999618 Forward= -0.027647
  HumMove    = (0.887,0.000,0.461) angle= 46.585256

ACCEL #175 t=2.5559 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1270.982,0.000,3110.590) mag= 3360.233154
  WishDir    = (0.937,0.000,-0.350) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008376
  Dot(Vel,Wish) = 100.724243
  addSpeed = 81.275757
  accelSpeed(x10) = 2774.618166
  expectedAdd = 81.275757
  RETURN     = (1347.107,0.000,3082.117)
  DELTA      = (76.125,0.000,-28.473) mag= 81.275818
  CameraLook = (0.350,0.000,0.937) angle= 90.000000
  CameraRight= (-0.937,0.000,0.350) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.328,0.000,0.945) angle= 91.386267
  RootRight  = (-0.945,0.000,0.328) dot= -0.999707
  Wish(root basis): Right= -0.999707 Forward= -0.024193
  HumMove    = (0.900,0.000,0.436) angle= 46.387106

ACCEL #176 t=2.5647 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1347.107,0.000,3082.117) mag= 3363.650635
  WishDir    = (0.925,0.000,-0.380) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008793
  Dot(Vel,Wish) = 73.506226
  addSpeed = 108.493774
  accelSpeed(x10) = 2912.565599
  expectedAdd = 108.493774
  RETURN     = (1447.446,0.000,3040.850)
  DELTA      = (100.339,0.000,-41.268) mag= 108.493767
  CameraLook = (0.380,0.000,0.925) angle= 90.000000
  CameraRight= (-0.925,0.000,0.380) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.350,0.000,0.937) angle= 91.848742
  RootRight  = (-0.937,0.000,0.350) dot= -0.999479
  Wish(root basis): Right= -0.999479 Forward= -0.032261
  HumMove    = (0.910,0.000,0.415) angle= 46.849474

ACCEL #177 t=2.5728 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1447.446,0.000,3040.850) mag= 3367.768555
  WishDir    = (0.912,0.000,-0.410) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007864
  Dot(Vel,Wish) = 73.373047
  addSpeed = 108.626953
  accelSpeed(x10) = 2604.705792
  expectedAdd = 108.626953
  RETURN     = (1546.522,0.000,2996.310)
  DELTA      = (99.076,0.000,-44.539) mag= 108.627060
  CameraLook = (0.410,0.000,0.912) angle= 90.000002
  CameraRight= (-0.912,0.000,0.410) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (0.380,0.000,0.925) angle= 91.848652
  RootRight  = (-0.925,0.000,0.380) dot= -0.999480
  Wish(root basis): Right= -0.999480 Forward= -0.032259
  HumMove    = (0.923,0.000,0.385) angle= 46.849478

ACCEL #178 t=2.5808 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1546.522,0.000,2996.310) mag= 3371.884521
  WishDir    = (0.898,0.000,-0.439) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008252
  Dot(Vel,Wish) = 73.240234
  addSpeed = 108.759766
  accelSpeed(x10) = 2733.406198
  expectedAdd = 108.759766
  RETURN     = (1644.228,0.000,2948.538)
  DELTA      = (97.706,0.000,-47.772) mag= 108.759743
  CameraLook = (0.439,0.000,0.898) angle= 90.000002
  CameraRight= (-0.898,0.000,0.439) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (0.410,0.000,0.912) angle= 91.848616
  RootRight  = (-0.912,0.000,0.410) dot= -0.999480
  Wish(root basis): Right= -0.999480 Forward= -0.032259
  HumMove    = (0.935,0.000,0.355) angle= 46.849474

ACCEL #179 t=2.5899 state=Enum.HumanoidStateType.Landed callerLine=305
  callerSource = =Opiumware
  Velocity   = (1644.228,0.000,2948.538) mag= 3375.998291
  WishDir    = (0.884,0.000,-0.468) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008981
  Dot(Vel,Wish) = 73.106934
  addSpeed = 108.893066
  accelSpeed(x10) = 2974.852767
  expectedAdd = 108.893066
  RETURN     = (1740.460,0.000,2897.576)
  DELTA      = (96.231,0.000,-50.963) mag= 108.892990
  CameraLook = (0.468,0.000,0.884) angle= 90.000002
  CameraRight= (-0.884,0.000,0.468) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (0.439,0.000,0.898) angle= 91.848324
  RootRight  = (-0.898,0.000,0.439) dot= -0.999480
  Wish(root basis): Right= -0.999480 Forward= -0.032254
  HumMove    = (0.946,0.000,0.325) angle= 46.849478

ACCEL #180 t=2.5977 state=Enum.HumanoidStateType.Landed callerLine=305
  callerSource = =Opiumware
  Velocity   = (1740.460,0.000,2897.576) mag= 3380.110107
  WishDir    = (0.868,0.000,-0.497) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007755
  Dot(Vel,Wish) = 69.078613
  addSpeed = 112.921387
  accelSpeed(x10) = 2568.711028
  expectedAdd = 112.921387
  RETURN     = (1838.429,0.000,2841.422)
  DELTA      = (97.969,0.000,-56.154) mag= 112.921318
  CameraLook = (0.497,0.000,0.868) angle= 89.999998
  CameraRight= (-0.868,0.000,0.497) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.468,0.000,0.884) angle= 91.914131
  RootRight  = (-0.884,0.000,0.468) dot= -0.999442
  Wish(root basis): Right= -0.999442 Forward= -0.033402
  HumMove    = (0.956,0.000,0.294) angle= 46.915525

ACCEL #181 t=2.6060 state=Enum.HumanoidStateType.Landed callerLine=305
  callerSource = =Opiumware
  Velocity   = (1838.429,0.000,2841.422) mag= 3384.301758
  WishDir    = (0.850,0.000,-0.526) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008297
  Dot(Vel,Wish) = 68.937988
  addSpeed = 113.062012
  accelSpeed(x10) = 2748.284425
  expectedAdd = 113.062012
  RETURN     = (1934.586,0.000,2781.950)
  DELTA      = (96.157,0.000,-59.471) mag= 113.062004
  CameraLook = (0.526,0.000,0.850) angle= 90.000000
  CameraRight= (-0.850,0.000,0.526) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.497,0.000,0.868) angle= 91.914129
  RootRight  = (-0.868,0.000,0.497) dot= -0.999442
  Wish(root basis): Right= -0.999442 Forward= -0.033402
  HumMove    = (0.965,0.000,0.262) angle= 46.915525

ACCEL #182 t=2.6143 state=Enum.HumanoidStateType.Landed callerLine=305
  callerSource = =Opiumware
  Velocity   = (1934.586,0.000,2781.950) mag= 3388.490723
  WishDir    = (0.832,0.000,-0.555) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008333
  Dot(Vel,Wish) = 64.892090
  addSpeed = 117.107910
  accelSpeed(x10) = 2760.126171
  expectedAdd = 117.107910
  RETURN     = (2031.994,0.000,2716.943)
  DELTA      = (97.408,0.000,-65.007) mag= 117.107941
  CameraLook = (0.555,0.000,0.832) angle= 90.000000
  CameraRight= (-0.832,0.000,0.555) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.526,0.000,0.850) angle= 91.980140
  RootRight  = (-0.850,0.000,0.526) dot= -0.999403
  Wish(root basis): Right= -0.999403 Forward= -0.034553
  HumMove    = (0.973,0.000,0.229) angle= 46.981584

ACCEL #183 t=2.6231 state=Enum.HumanoidStateType.Landed callerLine=305
  callerSource = =Opiumware
  Velocity   = (2031.994,0.000,2716.943) mag= 3392.754150
  WishDir    = (0.812,0.000,-0.584) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008900
  Dot(Vel,Wish) = 64.744263
  addSpeed = 117.255737
  accelSpeed(x10) = 2948.091148
  expectedAdd = 117.255737
  RETURN     = (2127.217,0.000,2648.521)
  DELTA      = (95.222,0.000,-68.422) mag= 117.255821
  CameraLook = (0.584,0.000,0.812) angle= 90.000000
  CameraRight= (-0.812,0.000,0.584) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.555,0.000,0.832) angle= 91.980107
  RootRight  = (-0.832,0.000,0.555) dot= -0.999403
  Wish(root basis): Right= -0.999403 Forward= -0.034553
  HumMove    = (0.981,0.000,0.196) angle= 46.981589

ACCEL #184 t=2.6315 state=Enum.HumanoidStateType.Landed callerLine=305
  callerSource = =Opiumware
  Velocity   = (2038.012,0.000,2537.456) mag= 3254.562256
  WishDir    = (0.999,0.000,0.034) mag= 1.000000
  Accel      = 3240.000000
  WishSpeed  = 20.400000
  dt         = 0.008387
  Dot(Vel,Wish) = 2122.168945
  addSpeed = -2101.768945
  accelSpeed(x10) = 5543.444018
  expectedAdd = 0.000000
  RETURN     = (2592.043,0.000,2556.093)
  DELTA      = (554.031,0.000,18.637) mag= 554.344360
  CameraLook = (0.611,0.000,0.791) angle= 50.392509
  CameraRight= (-0.791,0.000,0.611) dot= -0.770430
  Wish(cam basis): Right= -0.770430 Forward= 0.637525
  RootLook   = (0.584,0.000,0.812) angle= 52.372534
  RootRight  = (-0.812,0.000,0.584) dot= -0.791997
  Wish(root basis): Right= -0.791997 Forward= 0.610525
  HumMove    = (0.987,0.000,0.162) angle= 7.374057

ACCEL #185 t=2.6394 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (2491.612,0.000,2457.055) mag= 3499.321533
  WishDir    = (1.000,0.000,-0.018) mag= 1.000000
  Accel      = 3240.000000
  WishSpeed  = 20.400000
  dt         = 0.007749
  Dot(Vel,Wish) = 2446.354492
  addSpeed = -2425.954492
  accelSpeed(x10) = 5121.889292
  expectedAdd = 0.000000
  RETURN     = (3003.716,0.000,2447.707)
  DELTA      = (512.104,0.000,-9.348) mag= 512.188782
  CameraLook = (0.651,0.000,0.759) angle= 50.392513
  CameraRight= (-0.759,0.000,0.651) dot= -0.770430
  Wish(cam basis): Right= -0.770430 Forward= 0.637525
  RootLook   = (0.611,0.000,0.791) angle= 53.361827
  RootRight  = (-0.791,0.000,0.611) dot= -0.802420
  Wish(root basis): Right= -0.802420 Forward= 0.596760
  HumMove    = (0.992,0.000,0.127) angle= 8.364851

ACCEL #186 t=2.6483 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (2870.682,0.000,2339.299) mag= 3703.125000
  WishDir    = (0.998,0.000,-0.067) mag= 1.000000
  Accel      = 3240.000000
  WishSpeed  = 20.400000
  dt         = 0.008858
  Dot(Vel,Wish) = 2706.513916
  addSpeed = -2686.113916
  accelSpeed(x10) = 5854.755932
  expectedAdd = 0.000000
  RETURN     = (3402.955,0.000,2303.348)
  DELTA      = (532.273,0.000,-35.951) mag= 533.486145
  CameraLook = (0.688,0.000,0.725) angle= 50.370528
  CameraRight= (-0.725,0.000,0.688) dot= -0.770185
  Wish(cam basis): Right= -0.770185 Forward= 0.637820
  RootLook   = (0.652,0.000,0.759) angle= 53.207200
  RootRight  = (-0.759,0.000,0.652) dot= -0.800807
  Wish(root basis): Right= -0.800807 Forward= 0.598923
  HumMove    = (0.997,0.000,0.076) angle= 8.210759

ACCEL #187 t=2.6561 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (3269.608,0.000,2213.089) mag= 3948.176514
  WishDir    = (0.995,0.000,-0.099) mag= 1.000000
  Accel      = 3239.999807
  WishSpeed  = 20.400000
  dt         = 0.007837
  Dot(Vel,Wish) = 3034.009766
  addSpeed = -3013.609766
  accelSpeed(x10) = 5180.053598
  expectedAdd = 0.000000
  RETURN     = (3474.582,0.000,2192.661)
  DELTA      = (204.975,0.000,-20.429) mag= 205.990097
  CameraLook = (0.711,0.000,0.703) angle= 50.348589
  CameraRight= (-0.703,0.000,0.711) dot= -0.769941
  Wish(cam basis): Right= -0.769941 Forward= 0.638115
  RootLook   = (0.688,0.000,0.725) angle= 52.194226
  RootRight  = (-0.725,0.000,0.688) dot= -0.790093
  Wish(root basis): Right= -0.790093 Forward= 0.612987
  HumMove    = (1.000,0.000,0.026) angle= 7.197974

ACCEL #188 t=2.6650 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (3319.732,0.000,2094.941) mag= 3925.480469
  WishDir    = (0.991,0.000,-0.133) mag= 1.000000
  Accel      = 3240.000000
  WishSpeed  = 20.400000
  dt         = 0.008913
  Dot(Vel,Wish) = 3011.248291
  addSpeed = -2990.848291
  accelSpeed(x10) = 5891.356928
  expectedAdd = 0.000000
  RETURN     = (3546.447,0.000,2064.484)
  DELTA      = (226.715,0.000,-30.457) mag= 228.751709
  CameraLook = (0.735,0.000,0.678) angle= 50.326709
  CameraRight= (-0.678,0.000,0.735) dot= -0.769697
  Wish(cam basis): Right= -0.769697 Forward= 0.638409
  RootLook   = (0.711,0.000,0.703) angle= 52.305530
  RootRight  = (-0.703,0.000,0.711) dot= -0.791283
  Wish(root basis): Right= -0.791283 Forward= 0.611451
  HumMove    = (1.000,0.000,-0.006) angle= 7.308282

ACCEL #189 t=2.6731 state=Enum.HumanoidStateType.Running callerLine=305
  callerSource = =Opiumware
  Velocity   = (3721.680,0.000,2166.492) mag= 4306.343262
  WishDir    = (0.977,0.000,-0.211) mag= 1.000000
  Accel      = 3240.000000
  WishSpeed  = 20.400000
  dt         = 0.007711
  Dot(Vel,Wish) = 3180.407227
  addSpeed = -3160.007227
  accelSpeed(x10) = 5096.359575
  expectedAdd = 0.000000
  RETURN     = (3779.930,0.000,2153.911)
  DELTA      = (58.250,0.000,-12.581) mag= 59.592690
  CameraLook = (0.787,0.000,0.616) angle= 50.239677
  CameraRight= (-0.616,0.000,0.787) dot= -0.768727
  Wish(cam basis): Right= -0.768727 Forward= 0.639578
  RootLook   = (0.735,0.000,0.678) angle= 54.860855
  RootRight  = (-0.678,0.000,0.735) dot= -0.817757
  Wish(root basis): Right= -0.817757 Forward= 0.575564
  HumMove    = (0.999,0.000,-0.041) angle= 9.863383

ACCEL #190 t=2.6816 state=Enum.HumanoidStateType.Jumping callerLine=305
  callerSource = =Opiumware
  Velocity   = (3610.846,0.000,2057.563) mag= 4155.933105
  WishDir    = (0.977,0.000,-0.211) mag= 1.000000
  Accel      = 3240.000000
  WishSpeed  = 20.400000
  dt         = 0.008946
  Dot(Vel,Wish) = 3095.068604
  addSpeed = -3074.668604
  accelSpeed(x10) = 5913.196013
  expectedAdd = 0.000000
  RETURN     = (3752.511,0.000,2026.965)
  DELTA      = (141.665,0.000,-30.598) mag= 144.931503
  CameraLook = (0.787,0.000,0.616) angle= 50.239677
  CameraRight= (-0.616,0.000,0.787) dot= -0.768727
  Wish(cam basis): Right= -0.768727 Forward= 0.639578
  RootLook   = (0.787,0.000,0.616) angle= 50.236763
  RootRight  = (-0.616,0.000,0.787) dot= -0.768694
  Wish(root basis): Right= -0.768694 Forward= 0.639617
  HumMove    = (0.993,0.000,-0.121) angle= 5.239665

ACCEL #191 t=2.6893 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3752.511,0.000,2026.965) mag= 4264.965332
  WishDir    = (0.587,0.000,-0.810) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007729
  Dot(Vel,Wish) = 561.251099
  addSpeed = -379.251099
  accelSpeed(x10) = 2560.264382
  expectedAdd = 0.000000
  RETURN     = (3752.511,0.000,2026.965)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (0.810,0.000,0.587) angle= 90.000000
  CameraRight= (-0.587,0.000,0.810) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.787,0.000,0.616) angle= 92.111915
  RootRight  = (-0.616,0.000,0.787) dot= -0.999321
  Wish(root basis): Right= -0.999321 Forward= -0.036852
  HumMove    = (0.993,0.000,-0.121) angle= 47.113682

ACCEL #192 t=2.6983 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3752.511,0.000,2026.965) mag= 4264.965332
  WishDir    = (0.562,0.000,-0.827) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008850
  Dot(Vel,Wish) = 434.292969
  addSpeed = -252.292969
  accelSpeed(x10) = 2931.391280
  expectedAdd = 0.000000
  RETURN     = (3752.511,0.000,2026.965)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (0.827,0.000,0.562) angle= 90.000003
  CameraRight= (-0.562,0.000,0.827) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (0.810,0.000,0.587) angle= 91.716637
  RootRight  = (-0.587,0.000,0.810) dot= -0.999551
  Wish(root basis): Right= -0.999551 Forward= -0.029956
  HumMove    = (0.988,0.000,-0.158) angle= 46.717358

ACCEL #193 t=2.7059 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3752.511,0.000,2026.965) mag= 4264.965332
  WishDir    = (0.539,0.000,-0.842) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007821
  Dot(Vel,Wish) = 316.752075
  addSpeed = -134.752075
  accelSpeed(x10) = 2590.489896
  expectedAdd = 0.000000
  RETURN     = (3752.511,0.000,2026.965)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (0.842,0.000,0.539) angle= 90.000000
  CameraRight= (-0.539,0.000,0.842) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (0.827,0.000,0.562) angle= 91.584888
  RootRight  = (-0.562,0.000,0.827) dot= -0.999617
  Wish(root basis): Right= -0.999617 Forward= -0.027658
  HumMove    = (0.982,0.000,-0.187) angle= 46.585261

ACCEL #194 t=2.7231 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3752.511,0.000,2026.965) mag= 4264.965332
  WishDir    = (-0.512,0.000,0.859) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008336
  Dot(Vel,Wish) = -179.320068
  addSpeed = 361.320068
  accelSpeed(x10) = 2761.064910
  expectedAdd = 361.320068
  RETURN     = (3611.191,0.000,2264.164)
  DELTA      = (-141.320,0.000,237.199) mag= 276.106567
  CameraLook = (0.859,0.000,0.512) angle= 90.000000
  CameraRight= (-0.512,0.000,0.859) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.858,0.000,0.514) angle= 89.868068
  RootRight  = (-0.514,0.000,0.858) dot= 0.999997
  Wish(root basis): Right= 0.999997 Forward= 0.002303
  HumMove    = (0.243,0.000,0.970) angle= 44.867892

ACCEL #195 t=2.7306 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3611.191,0.000,2264.164) mag= 4262.292969
  WishDir    = (-0.512,0.000,0.859) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008334
  Dot(Vel,Wish) = 96.786621
  addSpeed = 85.213379
  accelSpeed(x10) = 2760.416153
  expectedAdd = 85.213379
  RETURN     = (3567.576,0.000,2337.370)
  DELTA      = (-43.615,0.000,73.206) mag= 85.213394
  CameraLook = (0.859,0.000,0.512) angle= 90.000000
  CameraRight= (-0.512,0.000,0.859) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.859,0.000,0.512) angle= 89.998870
  RootRight  = (-0.512,0.000,0.859) dot= 1.000000
  Wish(root basis): Right= 1.000000 Forward= 0.000020
  HumMove    = (0.246,0.000,0.969) angle= 44.999996

ACCEL #196 t=2.7393 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3567.576,0.000,2337.370) mag= 4265.078613
  WishDir    = (-0.511,0.000,0.860) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008295
  Dot(Vel,Wish) = 186.911987
  addSpeed = -4.911987
  accelSpeed(x10) = 2747.732534
  expectedAdd = 0.000000
  RETURN     = (3567.576,0.000,2337.370)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (0.860,0.000,0.511) angle= 90.000000
  CameraRight= (-0.511,0.000,0.860) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.859,0.000,0.512) angle= 89.933225
  RootRight  = (-0.512,0.000,0.859) dot= 0.999999
  Wish(root basis): Right= 0.999999 Forward= 0.001165
  HumMove    = (0.246,0.000,0.969) angle= 44.933946

ACCEL #197 t=2.7475 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3567.576,0.000,2337.370) mag= 4265.078613
  WishDir    = (-0.511,0.000,0.860) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008343
  Dot(Vel,Wish) = 186.911987
  addSpeed = -4.911987
  accelSpeed(x10) = 2763.493971
  expectedAdd = 0.000000
  RETURN     = (3567.576,0.000,2337.370)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (0.860,0.000,0.511) angle= 90.000000
  CameraRight= (-0.511,0.000,0.860) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.860,0.000,0.511) angle= 89.999797
  RootRight  = (-0.511,0.000,0.860) dot= 1.000000
  Wish(root basis): Right= 1.000000 Forward= 0.000004
  HumMove    = (0.247,0.000,0.969) angle= 44.999996

ACCEL #198 t=2.7566 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3567.576,0.000,2337.370) mag= 4265.078613
  WishDir    = (-0.513,0.000,0.858) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008984
  Dot(Vel,Wish) = 177.086548
  addSpeed = 4.913452
  accelSpeed(x10) = 2975.984313
  expectedAdd = 4.913452
  RETURN     = (3565.056,0.000,2341.588)
  DELTA      = (-2.520,0.000,4.218) mag= 4.913553
  CameraLook = (0.858,0.000,0.513) angle= 90.000000
  CameraRight= (-0.513,0.000,0.858) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.860,0.000,0.511) angle= 90.132086
  RootRight  = (-0.511,0.000,0.860) dot= 0.999997
  Wish(root basis): Right= 0.999997 Forward= -0.002305
  HumMove    = (0.247,0.000,0.969) angle= 45.132105

ACCEL #199 t=2.7641 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3565.056,0.000,2341.588) mag= 4265.285645
  WishDir    = (-0.520,0.000,0.854) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007716
  Dot(Vel,Wish) = 147.605225
  addSpeed = 34.394775
  accelSpeed(x10) = 2555.723699
  expectedAdd = 34.394775
  RETURN     = (3547.180,0.000,2370.973)
  DELTA      = (-17.876,0.000,29.385) mag= 34.394901
  CameraLook = (0.854,0.000,0.520) angle= 90.000002
  CameraRight= (-0.520,0.000,0.854) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.858,0.000,0.513) angle= 90.462388
  RootRight  = (-0.513,0.000,0.858) dot= 0.999967
  Wish(root basis): Right= 0.999967 Forward= -0.008070
  HumMove    = (0.244,0.000,0.970) angle= 45.462369

ACCEL #200 t=2.7725 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3547.180,0.000,2370.973) mag= 4266.614258
  WishDir    = (-0.535,0.000,0.845) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008372
  Dot(Vel,Wish) = 103.345459
  addSpeed = 78.654541
  accelSpeed(x10) = 2773.141419
  expectedAdd = 78.654541
  RETURN     = (3505.068,0.000,2437.404)
  DELTA      = (-42.112,0.000,66.431) mag= 78.654533
  CameraLook = (0.845,0.000,0.535) angle= 90.000000
  CameraRight= (-0.535,0.000,0.845) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.854,0.000,0.520) angle= 91.056735
  RootRight  = (-0.520,0.000,0.854) dot= 0.999830
  Wish(root basis): Right= 0.999830 Forward= -0.018442
  HumMove    = (0.237,0.000,0.972) angle= 46.056846

ACCEL #201 t=2.7810 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3505.068,0.000,2437.404) mag= 4269.243652
  WishDir    = (-0.554,0.000,0.833) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008243
  Dot(Vel,Wish) = 88.535278
  addSpeed = 93.464722
  accelSpeed(x10) = 2730.535687
  expectedAdd = 93.464722
  RETURN     = (3453.310,0.000,2515.229)
  DELTA      = (-51.758,0.000,77.825) mag= 93.464668
  CameraLook = (0.833,0.000,0.554) angle= 90.000000
  CameraRight= (-0.554,0.000,0.833) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.845,0.000,0.535) angle= 91.254644
  RootRight  = (-0.535,0.000,0.845) dot= 0.999760
  Wish(root basis): Right= 0.999760 Forward= -0.021896
  HumMove    = (0.219,0.000,0.976) angle= 46.255006

ACCEL #202 t=2.7897 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3453.310,0.000,2515.229) mag= 4272.204102
  WishDir    = (-0.578,0.000,0.816) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008857
  Dot(Vel,Wish) = 53.999634
  addSpeed = 128.000366
  accelSpeed(x10) = 2933.820341
  expectedAdd = 128.000366
  RETURN     = (3379.264,0.000,2619.639)
  DELTA      = (-74.045,0.000,104.410) mag= 128.000397
  CameraLook = (0.816,0.000,0.578) angle= 90.000000
  CameraRight= (-0.578,0.000,0.816) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.833,0.000,0.554) angle= 91.716882
  RootRight  = (-0.554,0.000,0.833) dot= 0.999551
  Wish(root basis): Right= 0.999551 Forward= -0.029961
  HumMove    = (0.197,0.000,0.980) angle= 46.717363

ACCEL #203 t=2.7976 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3379.264,0.000,2619.639) mag= 4275.738281
  WishDir    = (-0.602,0.000,0.799) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007906
  Dot(Vel,Wish) = 58.822144
  addSpeed = 123.177856
  accelSpeed(x10) = 2618.921379
  expectedAdd = 123.177856
  RETURN     = (3305.143,0.000,2718.020)
  DELTA      = (-74.122,0.000,98.381) mag= 123.177933
  CameraLook = (0.799,0.000,0.602) angle= 90.000003
  CameraRight= (-0.602,0.000,0.799) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.816,0.000,0.578) angle= 91.650621
  RootRight  = (-0.578,0.000,0.816) dot= 0.999585
  Wish(root basis): Right= 0.999585 Forward= -0.028805
  HumMove    = (0.168,0.000,0.986) angle= 46.651317

ACCEL #204 t=2.8064 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3305.143,0.000,2718.020) mag= 4279.205566
  WishDir    = (-0.620,0.000,0.785) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008377
  Dot(Vel,Wish) = 83.385010
  addSpeed = 98.614990
  accelSpeed(x10) = 2774.700842
  expectedAdd = 98.614990
  RETURN     = (3244.002,0.000,2795.393)
  DELTA      = (-61.141,0.000,77.374) mag= 98.614906
  CameraLook = (0.785,0.000,0.620) angle= 90.000002
  CameraRight= (-0.620,0.000,0.785) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.799,0.000,0.602) angle= 91.320292
  RootRight  = (-0.602,0.000,0.799) dot= 0.999735
  Wish(root basis): Right= 0.999735 Forward= -0.023041
  HumMove    = (0.139,0.000,0.990) angle= 46.321052

ACCEL #205 t=2.8146 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3244.002,0.000,2795.393) mag= 4282.262207
  WishDir    = (-0.641,0.000,0.767) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008783
  Dot(Vel,Wish) = 63.569824
  addSpeed = 118.430176
  accelSpeed(x10) = 2909.349886
  expectedAdd = 118.430176
  RETURN     = (3168.033,0.000,2886.247)
  DELTA      = (-75.969,0.000,90.854) mag= 118.430122
  CameraLook = (0.767,0.000,0.641) angle= 89.999997
  CameraRight= (-0.641,0.000,0.767) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.785,0.000,0.620) angle= 91.584628
  RootRight  = (-0.620,0.000,0.785) dot= 0.999618
  Wish(root basis): Right= 0.999618 Forward= -0.027653
  HumMove    = (0.116,0.000,0.993) angle= 46.585270

ACCEL #206 t=2.8231 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3168.033,0.000,2886.247) mag= 4285.656738
  WishDir    = (-0.668,0.000,0.744) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008417
  Dot(Vel,Wish) = 28.893799
  addSpeed = 153.106201
  accelSpeed(x10) = 2788.074557
  expectedAdd = 153.106201
  RETURN     = (3065.686,0.000,3000.118)
  DELTA      = (-102.346,0.000,113.871) mag= 153.106094
  CameraLook = (0.744,0.000,0.668) angle= 90.000002
  CameraRight= (-0.668,0.000,0.744) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.767,0.000,0.641) angle= 92.046931
  RootRight  = (-0.641,0.000,0.767) dot= 0.999362
  Wish(root basis): Right= 0.999362 Forward= -0.035718
  HumMove    = (0.089,0.000,0.996) angle= 47.047633

ACCEL #207 t=2.8308 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (3065.686,0.000,3000.118) mag= 4289.421875
  WishDir    = (-0.695,0.000,0.719) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007714
  Dot(Vel,Wish) = 23.814453
  addSpeed = 158.185547
  accelSpeed(x10) = 2555.088824
  expectedAdd = 158.185547
  RETURN     = (2955.677,0.000,3113.787)
  DELTA      = (-110.009,0.000,113.669) mag= 158.185394
  CameraLook = (0.719,0.000,0.695) angle= 89.999998
  CameraRight= (-0.695,0.000,0.719) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.744,0.000,0.668) angle= 92.112814
  RootRight  = (-0.668,0.000,0.744) dot= 0.999320
  Wish(root basis): Right= 0.999320 Forward= -0.036867
  HumMove    = (0.053,0.000,0.999) angle= 47.113682

ACCEL #208 t=2.8390 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2955.677,0.000,3113.787) mag= 4293.215332
  WishDir    = (-0.721,0.000,0.692) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008327
  Dot(Vel,Wish) = 23.673584
  addSpeed = 158.326416
  accelSpeed(x10) = 2758.401088
  expectedAdd = 158.326416
  RETURN     = (2841.449,0.000,3223.419)
  DELTA      = (-114.228,0.000,109.632) mag= 158.326370
  CameraLook = (0.692,0.000,0.721) angle= 90.000000
  CameraRight= (-0.721,0.000,0.692) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.719,0.000,0.695) angle= 92.112734
  RootRight  = (-0.695,0.000,0.719) dot= 0.999320
  Wish(root basis): Right= 0.999320 Forward= -0.036866
  HumMove    = (0.016,0.000,1.000) angle= 47.113696

ACCEL #209 t=2.8482 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2841.449,0.000,3223.419) mag= 4297.006348
  WishDir    = (-0.739,0.000,0.674) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008879
  Dot(Vel,Wish) = 73.067871
  addSpeed = 108.932129
  accelSpeed(x10) = 2940.941862
  expectedAdd = 108.932129
  RETURN     = (2760.970,0.000,3296.831)
  DELTA      = (-80.479,0.000,73.412) mag= 108.932137
  CameraLook = (0.674,0.000,0.739) angle= 90.000000
  CameraRight= (-0.739,0.000,0.674) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.692,0.000,0.721) angle= 91.452196
  RootRight  = (-0.721,0.000,0.692) dot= 0.999679
  Wish(root basis): Right= 0.999679 Forward= -0.025343
  HumMove    = (-0.021,0.000,1.000) angle= 46.453158

ACCEL #210 t=2.8559 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2760.970,0.000,3296.831) mag= 4300.238281
  WishDir    = (-0.753,0.000,0.658) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007754
  Dot(Vel,Wish) = 87.855957
  addSpeed = 94.144043
  accelSpeed(x10) = 2568.545368
  expectedAdd = 94.144043
  RETURN     = (2690.043,0.000,3358.738)
  DELTA      = (-70.927,0.000,61.907) mag= 94.144089
  CameraLook = (0.658,0.000,0.753) angle= 90.000002
  CameraRight= (-0.753,0.000,0.658) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.674,0.000,0.739) angle= 91.254230
  RootRight  = (-0.739,0.000,0.674) dot= 0.999760
  Wish(root basis): Right= 0.999760 Forward= -0.021889
  HumMove    = (-0.046,0.000,0.999) angle= 46.255001

ACCEL #211 t=2.8641 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2690.043,0.000,3358.738) mag= 4303.190918
  WishDir    = (-0.775,0.000,0.632) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008337
  Dot(Vel,Wish) = 38.188477
  addSpeed = 143.811523
  accelSpeed(x10) = 2761.672021
  expectedAdd = 143.811523
  RETURN     = (2578.597,0.000,3449.631)
  DELTA      = (-111.446,0.000,90.893) mag= 143.811386
  CameraLook = (0.632,0.000,0.775) angle= 90.000002
  CameraRight= (-0.775,0.000,0.632) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.658,0.000,0.753) angle= 91.914881
  RootRight  = (-0.753,0.000,0.658) dot= 0.999442
  Wish(root basis): Right= 0.999442 Forward= -0.033415
  HumMove    = (-0.068,0.000,0.998) angle= 46.915529

ACCEL #212 t=2.8723 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2578.597,0.000,3449.631) mag= 4306.868652
  WishDir    = (-0.795,0.000,0.607) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008333
  Dot(Vel,Wish) = 43.029785
  addSpeed = 138.970215
  accelSpeed(x10) = 2760.153935
  expectedAdd = 138.970215
  RETURN     = (2468.124,0.000,3533.943)
  DELTA      = (-110.473,0.000,84.312) mag= 138.970276
  CameraLook = (0.607,0.000,0.795) angle= 89.999998
  CameraRight= (-0.795,0.000,0.607) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.632,0.000,0.775) angle= 91.848669
  RootRight  = (-0.775,0.000,0.632) dot= 0.999480
  Wish(root basis): Right= 0.999480 Forward= -0.032260
  HumMove    = (-0.101,0.000,0.995) angle= 46.849483

ACCEL #213 t=2.8816 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2468.124,0.000,3533.943) mag= 4310.497559
  WishDir    = (-0.810,0.000,0.586) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008940
  Dot(Vel,Wish) = 72.725708
  addSpeed = 109.274292
  accelSpeed(x10) = 2961.396069
  expectedAdd = 109.274292
  RETURN     = (2379.604,0.000,3598.014)
  DELTA      = (-88.520,0.000,64.071) mag= 109.274338
  CameraLook = (0.586,0.000,0.810) angle= 90.000002
  CameraRight= (-0.810,0.000,0.586) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.607,0.000,0.795) angle= 91.452303
  RootRight  = (-0.795,0.000,0.607) dot= 0.999679
  Wish(root basis): Right= 0.999679 Forward= -0.025345
  HumMove    = (-0.133,0.000,0.991) angle= 46.453153

ACCEL #214 t=2.8891 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2379.604,0.000,3598.014) mag= 4313.725098
  WishDir    = (-0.826,0.000,0.564) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007810
  Dot(Vel,Wish) = 62.698730
  addSpeed = 119.301270
  accelSpeed(x10) = 2587.108677
  expectedAdd = 119.301270
  RETURN     = (2281.064,0.000,3665.264)
  DELTA      = (-98.540,0.000,67.250) mag= 119.301231
  CameraLook = (0.564,0.000,0.826) angle= 90.000000
  CameraRight= (-0.826,0.000,0.564) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.586,0.000,0.810) angle= 91.584541
  RootRight  = (-0.810,0.000,0.586) dot= 0.999618
  Wish(root basis): Right= 0.999618 Forward= -0.027652
  HumMove    = (-0.158,0.000,0.987) angle= 46.585275

ACCEL #215 t=2.8973 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2281.064,0.000,3665.264) mag= 4317.107422
  WishDir    = (-0.843,0.000,0.538) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008275
  Dot(Vel,Wish) = 47.675537
  addSpeed = 134.324463
  accelSpeed(x10) = 2741.011125
  expectedAdd = 134.324463
  RETURN     = (2167.812,0.000,3737.494)
  DELTA      = (-113.252,0.000,72.229) mag= 134.324493
  CameraLook = (0.538,0.000,0.843) angle= 89.999997
  CameraRight= (-0.843,0.000,0.538) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.564,0.000,0.826) angle= 91.782685
  RootRight  = (-0.826,0.000,0.564) dot= 0.999516
  Wish(root basis): Right= 0.999516 Forward= -0.031109
  HumMove    = (-0.185,0.000,0.983) angle= 46.783426

ACCEL #216 t=2.9061 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2167.812,0.000,3737.494) mag= 4320.679199
  WishDir    = (-0.863,0.000,0.505) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008292
  Dot(Vel,Wish) = 17.679077
  addSpeed = 164.320923
  accelSpeed(x10) = 2746.738575
  expectedAdd = 164.320923
  RETURN     = (2026.009,0.000,3820.519)
  DELTA      = (-141.803,0.000,83.026) mag= 164.320953
  CameraLook = (0.505,0.000,0.863) angle= 90.000000
  CameraRight= (-0.863,0.000,0.505) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.538,0.000,0.843) angle= 92.178953
  RootRight  = (-0.843,0.000,0.538) dot= 0.999277
  Wish(root basis): Right= 0.999277 Forward= -0.038021
  HumMove    = (-0.216,0.000,0.976) angle= 47.179743

ACCEL #217 t=2.9149 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (2026.009,0.000,3820.519) mag= 4324.474609
  WishDir    = (-0.883,0.000,0.469) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.009011
  Dot(Vel,Wish) = 2.578369
  addSpeed = 179.421631
  accelSpeed(x10) = 2984.913902
  expectedAdd = 179.421631
  RETURN     = (1867.547,0.000,3904.673)
  DELTA      = (-158.463,0.000,84.153) mag= 179.421722
  CameraLook = (0.469,0.000,0.883) angle= 89.999998
  CameraRight= (-0.883,0.000,0.469) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.505,0.000,0.863) angle= 92.376942
  RootRight  = (-0.863,0.000,0.505) dot= 0.999140
  Wish(root basis): Right= 0.999140 Forward= -0.041474
  HumMove    = (-0.253,0.000,0.967) angle= 47.377905

ACCEL #218 t=2.9224 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1867.547,0.000,3904.673) mag= 4328.301758
  WishDir    = (-0.894,0.000,0.448) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007725
  Dot(Vel,Wish) = 77.263672
  addSpeed = 104.736328
  accelSpeed(x10) = 2558.760024
  expectedAdd = 104.736328
  RETURN     = (1773.883,0.000,3951.543)
  DELTA      = (-93.664,0.000,46.870) mag= 104.736320
  CameraLook = (0.448,0.000,0.894) angle= 90.000000
  CameraRight= (-0.894,0.000,0.448) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.469,0.000,0.883) angle= 91.386006
  RootRight  = (-0.883,0.000,0.469) dot= 0.999707
  Wish(root basis): Right= 0.999707 Forward= -0.024188
  HumMove    = (-0.293,0.000,0.956) angle= 46.387101

ACCEL #219 t=2.9308 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1773.883,0.000,3951.543) mag= 4331.437500
  WishDir    = (-0.902,0.000,0.431) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008302
  Dot(Vel,Wish) = 102.148804
  addSpeed = 79.851196
  accelSpeed(x10) = 2749.802510
  expectedAdd = 79.851196
  RETURN     = (1701.827,0.000,3985.954)
  DELTA      = (-72.056,0.000,34.411) mag= 79.851212
  CameraLook = (0.431,0.000,0.902) angle= 90.000000
  CameraRight= (-0.902,0.000,0.431) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.447,0.000,0.894) angle= 91.056038
  RootRight  = (-0.894,0.000,0.447) dot= 0.999830
  Wish(root basis): Right= 0.999830 Forward= -0.018430
  HumMove    = (-0.316,0.000,0.949) angle= 46.056846

ACCEL #220 t=2.9394 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1701.827,0.000,3985.954) mag= 4334.056152
  WishDir    = (-0.912,0.000,0.410) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008339
  Dot(Vel,Wish) = 82.119385
  addSpeed = 99.880615
  accelSpeed(x10) = 2762.348234
  expectedAdd = 99.880615
  RETURN     = (1610.728,0.000,4026.907)
  DELTA      = (-91.099,0.000,40.953) mag= 99.880653
  CameraLook = (0.410,0.000,0.912) angle= 90.000000
  CameraRight= (-0.912,0.000,0.410) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.431,0.000,0.902) angle= 91.320476
  RootRight  = (-0.902,0.000,0.431) dot= 0.999735
  Wish(root basis): Right= 0.999735 Forward= -0.023045
  HumMove    = (-0.333,0.000,0.943) angle= 46.321052

ACCEL #221 t=2.9474 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1610.728,0.000,4026.907) mag= 4337.098145
  WishDir    = (-0.921,0.000,0.389) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008313
  Dot(Vel,Wish) = 82.049072
  addSpeed = 99.950928
  accelSpeed(x10) = 2753.666981
  expectedAdd = 99.950928
  RETURN     = (1518.644,0.000,4065.776)
  DELTA      = (-92.083,0.000,38.869) mag= 99.950890
  CameraLook = (0.389,0.000,0.921) angle= 90.000000
  CameraRight= (-0.921,0.000,0.389) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.410,0.000,0.912) angle= 91.320457
  RootRight  = (-0.912,0.000,0.410) dot= 0.999734
  Wish(root basis): Right= 0.999734 Forward= -0.023044
  HumMove    = (-0.355,0.000,0.935) angle= 46.321052

ACCEL #222 t=2.9567 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1518.644,0.000,4065.776) mag= 4340.139648
  WishDir    = (-0.929,0.000,0.371) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008987
  Dot(Vel,Wish) = 96.986206
  addSpeed = 85.013794
  accelSpeed(x10) = 2976.702173
  expectedAdd = 85.013794
  RETURN     = (1439.689,0.000,4097.295)
  DELTA      = (-78.955,0.000,31.519) mag= 85.013741
  CameraLook = (0.371,0.000,0.929) angle= 90.000002
  CameraRight= (-0.929,0.000,0.371) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.389,0.000,0.921) angle= 91.122279
  RootRight  = (-0.921,0.000,0.389) dot= 0.999808
  Wish(root basis): Right= 0.999808 Forward= -0.019586
  HumMove    = (-0.376,0.000,0.926) angle= 46.122889

ACCEL #223 t=2.9641 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1439.689,0.000,4097.295) mag= 4342.871582
  WishDir    = (-0.937,0.000,0.350) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007726
  Dot(Vel,Wish) = 86.921265
  addSpeed = 95.078735
  accelSpeed(x10) = 2559.022242
  expectedAdd = 95.078735
  RETURN     = (1350.636,0.000,4130.603)
  DELTA      = (-89.053,0.000,33.308) mag= 95.078651
  CameraLook = (0.350,0.000,0.937) angle= 90.000002
  CameraRight= (-0.937,0.000,0.350) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.371,0.000,0.929) angle= 91.254468
  RootRight  = (-0.929,0.000,0.371) dot= 0.999760
  Wish(root basis): Right= 0.999760 Forward= -0.021893
  HumMove    = (-0.395,0.000,0.919) angle= 46.255006

ACCEL #224 t=2.9729 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1350.636,0.000,4130.603) mag= 4345.813965
  WishDir    = (-0.944,0.000,0.329) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008336
  Dot(Vel,Wish) = 81.848022
  addSpeed = 100.151978
  accelSpeed(x10) = 2761.313246
  expectedAdd = 100.151978
  RETURN     = (1256.047,0.000,4163.517)
  DELTA      = (-94.589,0.000,32.914) mag= 100.152016
  CameraLook = (0.329,0.000,0.944) angle= 90.000000
  CameraRight= (-0.944,0.000,0.329) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.350,0.000,0.937) angle= 91.320492
  RootRight  = (-0.937,0.000,0.350) dot= 0.999734
  Wish(root basis): Right= 0.999734 Forward= -0.023045
  HumMove    = (-0.415,0.000,0.910) angle= 46.321057

ACCEL #225 t=2.9811 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1256.047,0.000,4163.517) mag= 4348.853027
  WishDir    = (-0.952,0.000,0.305) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008335
  Dot(Vel,Wish) = 71.752075
  addSpeed = 110.247925
  accelSpeed(x10) = 2760.816266
  expectedAdd = 110.247925
  RETURN     = (1151.037,0.000,4197.096)
  DELTA      = (-105.010,0.000,33.579) mag= 110.247932
  CameraLook = (0.305,0.000,0.952) angle= 90.000000
  CameraRight= (-0.952,0.000,0.305) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.329,0.000,0.944) angle= 91.452592
  RootRight  = (-0.944,0.000,0.329) dot= 0.999679
  Wish(root basis): Right= 0.999679 Forward= -0.025350
  HumMove    = (-0.435,0.000,0.900) angle= 46.453158

ACCEL #226 t=2.9897 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1151.037,0.000,4197.096) mag= 4352.068359
  WishDir    = (-0.960,0.000,0.281) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008858
  Dot(Vel,Wish) = 76.687866
  addSpeed = 105.312134
  accelSpeed(x10) = 2934.192998
  expectedAdd = 105.312134
  RETURN     = (1049.981,0.000,4226.734)
  DELTA      = (-101.056,0.000,29.638) mag= 105.312126
  CameraLook = (0.281,0.000,0.960) angle= 89.999998
  CameraRight= (-0.960,0.000,0.281) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.305,0.000,0.952) angle= 91.386469
  RootRight  = (-0.952,0.000,0.305) dot= 0.999707
  Wish(root basis): Right= 0.999707 Forward= -0.024196
  HumMove    = (-0.458,0.000,0.889) angle= 46.387096

ACCEL #227 t=2.9981 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (1049.981,0.000,4226.734) mag= 4355.196777
  WishDir    = (-0.967,0.000,0.256) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008052
  Dot(Vel,Wish) = 66.571228
  addSpeed = 115.428772
  accelSpeed(x10) = 2667.061753
  expectedAdd = 115.428772
  RETURN     = (938.396,0.000,4256.271)
  DELTA      = (-111.586,0.000,29.538) mag= 115.428810
  CameraLook = (0.256,0.000,0.967) angle= 90.000001
  CameraRight= (-0.967,0.000,0.256) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.281,0.000,0.960) angle= 91.518549
  RootRight  = (-0.960,0.000,0.281) dot= 0.999649
  Wish(root basis): Right= 0.999649 Forward= -0.026501
  HumMove    = (-0.480,0.000,0.878) angle= 46.519212

ACCEL #228 t=3.0059 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (938.396,0.000,4256.271) mag= 4358.489746
  WishDir    = (-0.973,0.000,0.230) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008057
  Dot(Vel,Wish) = 66.483887
  addSpeed = 115.516113
  accelSpeed(x10) = 2668.952496
  expectedAdd = 115.516113
  RETURN     = (825.981,0.000,4282.860)
  DELTA      = (-112.414,0.000,26.589) mag= 115.516113
  CameraLook = (0.230,0.000,0.973) angle= 90.000001
  CameraRight= (-0.973,0.000,0.230) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.256,0.000,0.967) angle= 91.518507
  RootRight  = (-0.967,0.000,0.256) dot= 0.999649
  Wish(root basis): Right= 0.999649 Forward= -0.026500
  HumMove    = (-0.503,0.000,0.865) angle= 46.519203

ACCEL #229 t=3.0141 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (825.981,0.000,4282.860) mag= 4361.781738
  WishDir    = (-0.981,0.000,0.194) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008331
  Dot(Vel,Wish) = 21.143494
  addSpeed = 160.856506
  accelSpeed(x10) = 2759.643382
  expectedAdd = 160.856506
  RETURN     = (668.185,0.000,4314.087)
  DELTA      = (-157.797,0.000,31.227) mag= 160.856567
  CameraLook = (0.194,0.000,0.981) angle= 90.000000
  CameraRight= (-0.981,0.000,0.194) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.230,0.000,0.973) angle= 92.112954
  RootRight  = (-0.973,0.000,0.230) dot= 0.999320
  Wish(root basis): Right= 0.999320 Forward= -0.036870
  HumMove    = (-0.525,0.000,0.851) angle= 47.113686

ACCEL #230 t=3.0226 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (668.185,0.000,4314.087) mag= 4365.525879
  WishDir    = (-0.987,0.000,0.162) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008326
  Dot(Vel,Wish) = 41.135193
  addSpeed = 140.864807
  accelSpeed(x10) = 2758.069768
  expectedAdd = 140.864807
  RETURN     = (529.189,0.000,4336.958)
  DELTA      = (-138.996,0.000,22.872) mag= 140.864838
  CameraLook = (0.162,0.000,0.987) angle= 90.000000
  CameraRight= (-0.987,0.000,0.162) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.194,0.000,0.981) angle= 91.848542
  RootRight  = (-0.981,0.000,0.194) dot= 0.999480
  Wish(root basis): Right= 0.999480 Forward= -0.032258
  HumMove    = (-0.556,0.000,0.831) angle= 46.849478

ACCEL #231 t=3.0312 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (529.189,0.000,4336.958) mag= 4369.124512
  WishDir    = (-0.990,0.000,0.144) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008347
  Dot(Vel,Wish) = 101.452942
  addSpeed = 80.547058
  accelSpeed(x10) = 2764.915498
  expectedAdd = 80.547058
  RETURN     = (449.483,0.000,4348.568)
  DELTA      = (-79.706,0.000,11.610) mag= 80.547066
  CameraLook = (0.144,0.000,0.990) angle= 90.000001
  CameraRight= (-0.990,0.000,0.144) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.162,0.000,0.987) angle= 91.055947
  RootRight  = (-0.987,0.000,0.162) dot= 0.999830
  Wish(root basis): Right= 0.999830 Forward= -0.018429
  HumMove    = (-0.583,0.000,0.813) angle= 46.056846

ACCEL #232 t=3.0393 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (449.483,0.000,4348.568) mag= 4371.736816
  WishDir    = (-0.992,0.000,0.125) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008311
  Dot(Vel,Wish) = 96.366455
  addSpeed = 85.633545
  accelSpeed(x10) = 2753.045988
  expectedAdd = 85.633545
  RETURN     = (364.518,0.000,4359.249)
  DELTA      = (-84.965,0.000,10.680) mag= 85.633591
  CameraLook = (0.125,0.000,0.992) angle= 90.000000
  CameraRight= (-0.992,0.000,0.125) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.144,0.000,0.990) angle= 91.122275
  RootRight  = (-0.990,0.000,0.144) dot= 0.999808
  Wish(root basis): Right= 0.999808 Forward= -0.019586
  HumMove    = (-0.598,0.000,0.802) angle= 46.122894

ACCEL #233 t=3.0476 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (364.518,0.000,4359.249) mag= 4374.462402
  WishDir    = (-0.995,0.000,0.102) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008389
  Dot(Vel,Wish) = 81.187073
  addSpeed = 100.812927
  accelSpeed(x10) = 2778.634415
  expectedAdd = 100.812927
  RETURN     = (264.229,0.000,4369.512)
  DELTA      = (-100.289,0.000,10.264) mag= 100.812920
  CameraLook = (0.102,0.000,0.995) angle= 90.000000
  CameraRight= (-0.995,0.000,0.102) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.125,0.000,0.992) angle= 91.320494
  RootRight  = (-0.992,0.000,0.125) dot= 0.999734
  Wish(root basis): Right= 0.999734 Forward= -0.023045
  HumMove    = (-0.613,0.000,0.790) angle= 46.321052

ACCEL #234 t=3.0562 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (264.229,0.000,4369.512) mag= 4377.494141
  WishDir    = (-0.997,0.000,0.080) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008738
  Dot(Vel,Wish) = 86.162323
  addSpeed = 95.837677
  accelSpeed(x10) = 2894.361220
  expectedAdd = 95.837677
  RETURN     = (168.699,0.000,4377.179)
  DELTA      = (-95.531,0.000,7.667) mag= 95.837669
  CameraLook = (0.080,0.000,0.997) angle= 90.000000
  CameraRight= (-0.997,0.000,0.080) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.102,0.000,0.995) angle= 91.254411
  RootRight  = (-0.995,0.000,0.102) dot= 0.999760
  Wish(root basis): Right= 0.999760 Forward= -0.021892
  HumMove    = (-0.631,0.000,0.775) angle= 46.255001

ACCEL #235 t=3.0643 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (168.699,0.000,4377.179) mag= 4380.428711
  WishDir    = (-0.998,0.000,0.059) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007920
  Dot(Vel,Wish) = 91.147522
  addSpeed = 90.852478
  accelSpeed(x10) = 2623.296711
  expectedAdd = 90.852478
  RETURN     = (78.006,0.000,4382.566)
  DELTA      = (-90.693,0.000,5.387) mag= 90.852486
  CameraLook = (0.059,0.000,0.998) angle= 90.000000
  CameraRight= (-0.998,0.000,0.059) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.080,0.000,0.997) angle= 91.188352
  RootRight  = (-0.997,0.000,0.080) dot= 0.999785
  Wish(root basis): Right= 0.999785 Forward= -0.020739
  HumMove    = (-0.648,0.000,0.761) angle= 46.188934

ACCEL #236 t=3.0724 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (78.006,0.000,4382.566) mag= 4383.259766
  WishDir    = (-0.999,0.000,0.037) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008308
  Dot(Vel,Wish) = 86.035927
  addSpeed = 95.964073
  accelSpeed(x10) = 2752.038455
  expectedAdd = 95.964073
  RETURN     = (-17.891,0.000,4386.157)
  DELTA      = (-95.897,0.000,3.591) mag= 95.964073
  CameraLook = (0.037,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,0.037) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.059,0.000,0.998) angle= 91.254426
  RootRight  = (-0.998,0.000,0.059) dot= 0.999760
  Wish(root basis): Right= 0.999760 Forward= -0.021892
  HumMove    = (-0.664,0.000,0.748) angle= 46.255011

ACCEL #237 t=3.0815 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-17.891,0.000,4386.157) mag= 4386.192871
  WishDir    = (-1.000,0.000,0.014) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008964
  Dot(Vel,Wish) = 80.916336
  addSpeed = 101.083664
  accelSpeed(x10) = 2969.166347
  expectedAdd = 101.083664
  RETURN     = (-118.964,0.000,4387.609)
  DELTA      = (-101.073,0.000,1.453) mag= 101.083664
  CameraLook = (0.014,0.000,1.000) angle= 90.000000
  CameraRight= (-1.000,0.000,0.014) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (0.037,0.000,0.999) angle= 91.320467
  RootRight  = (-0.999,0.000,0.037) dot= 0.999735
  Wish(root basis): Right= 0.999735 Forward= -0.023044
  HumMove    = (-0.680,0.000,0.733) angle= 46.321052

ACCEL #238 t=3.0892 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-118.964,0.000,4387.609) mag= 4389.221680
  WishDir    = (-1.000,0.000,-0.010) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007710
  Dot(Vel,Wish) = 75.787292
  addSpeed = 106.212708
  accelSpeed(x10) = 2553.984579
  expectedAdd = 106.212708
  RETURN     = (-225.172,0.000,4386.564)
  DELTA      = (-106.208,0.000,-1.045) mag= 106.212708
  CameraLook = (-0.010,0.000,1.000) angle= 90.000000
  CameraRight= (-1.000,0.000,-0.010) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (0.014,0.000,1.000) angle= 91.386485
  RootRight  = (-1.000,0.000,0.014) dot= 0.999707
  Wish(root basis): Right= 0.999707 Forward= -0.024196
  HumMove    = (-0.697,0.000,0.717) angle= 46.387106

ACCEL #239 t=3.0983 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-225.172,0.000,4386.564) mag= 4392.339844
  WishDir    = (-0.999,0.000,-0.035) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008895
  Dot(Vel,Wish) = 70.648392
  addSpeed = 111.351608
  accelSpeed(x10) = 2946.545298
  expectedAdd = 111.351608
  RETURN     = (-336.454,0.000,4382.646)
  DELTA      = (-111.283,0.000,-3.919) mag= 111.351639
  CameraLook = (-0.035,0.000,0.999) angle= 90.000000
  CameraRight= (-0.999,0.000,-0.035) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.010,0.000,1.000) angle= 91.452516
  RootRight  = (-1.000,0.000,-0.010) dot= 0.999679
  Wish(root basis): Right= 0.999679 Forward= -0.025348
  HumMove    = (-0.714,0.000,0.700) angle= 46.453162

ACCEL #240 t=3.1064 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-336.454,0.000,4382.646) mag= 4395.541504
  WishDir    = (-0.998,0.000,-0.055) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008139
  Dot(Vel,Wish) = 95.899567
  addSpeed = 86.100433
  accelSpeed(x10) = 2695.824247
  expectedAdd = 86.100433
  RETURN     = (-422.425,0.000,4377.930)
  DELTA      = (-85.971,0.000,-4.716) mag= 86.100433
  CameraLook = (-0.055,0.000,0.998) angle= 90.000000
  CameraRight= (-0.998,0.000,-0.055) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.035,0.000,0.999) angle= 91.122238
  RootRight  = (-0.999,0.000,-0.035) dot= 0.999808
  Wish(root basis): Right= 0.999808 Forward= -0.019585
  HumMove    = (-0.732,0.000,0.682) angle= 46.122894

ACCEL #241 t=3.1142 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-422.425,0.000,4377.930) mag= 4398.262207
  WishDir    = (-0.995,0.000,-0.102) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008011
  Dot(Vel,Wish) = -25.838257
  addSpeed = 207.838257
  accelSpeed(x10) = 2653.674156
  expectedAdd = 207.838257
  RETURN     = (-629.182,0.000,4356.753)
  DELTA      = (-206.757,0.000,-21.177) mag= 207.838257
  CameraLook = (-0.102,0.000,0.995) angle= 90.000001
  CameraRight= (-0.995,0.000,-0.102) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (-0.055,0.000,0.998) angle= 92.707607
  RootRight  = (-0.998,0.000,-0.055) dot= 0.998884
  Wish(root basis): Right= 0.998884 Forward= -0.047239
  HumMove    = (-0.745,0.000,0.667) angle= 47.708169

ACCEL #242 t=3.1226 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-629.182,0.000,4356.753) mag= 4401.950195
  WishDir    = (-0.993,0.000,-0.117) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008318
  Dot(Vel,Wish) = 116.066437
  addSpeed = 65.933563
  accelSpeed(x10) = 2755.295815
  expectedAdd = 65.933563
  RETURN     = (-694.664,0.000,4349.053)
  DELTA      = (-65.482,0.000,-7.700) mag= 65.933548
  CameraLook = (-0.117,0.000,0.993) angle= 90.000000
  CameraRight= (-0.993,0.000,-0.117) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.102,0.000,0.995) angle= 90.857619
  RootRight  = (-0.995,0.000,-0.102) dot= 0.999888
  Wish(root basis): Right= 0.999888 Forward= -0.014968
  HumMove    = (-0.775,0.000,0.631) angle= 45.858690

ACCEL #243 t=3.1317 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-694.664,0.000,4349.053) mag= 4404.181641
  WishDir    = (-0.991,0.000,-0.132) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.009071
  Dot(Vel,Wish) = 116.033020
  addSpeed = 65.966980
  accelSpeed(x10) = 3004.581456
  expectedAdd = 65.966980
  RETURN     = (-760.057,0.000,4340.368)
  DELTA      = (-65.393,0.000,-8.685) mag= 65.966988
  CameraLook = (-0.132,0.000,0.991) angle= 90.000000
  CameraRight= (-0.991,0.000,-0.132) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.117,0.000,0.993) angle= 90.858070
  RootRight  = (-0.993,0.000,-0.117) dot= 0.999888
  Wish(root basis): Right= 0.999888 Forward= -0.014976
  HumMove    = (-0.785,0.000,0.620) angle= 45.858685

ACCEL #244 t=3.1391 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-760.057,0.000,4340.368) mag= 4406.413086
  WishDir    = (-0.990,0.000,-0.140) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007594
  Dot(Vel,Wish) = 146.466064
  addSpeed = 35.533936
  accelSpeed(x10) = 2515.519417
  expectedAdd = 35.533936
  RETURN     = (-795.243,0.000,4335.405)
  DELTA      = (-35.186,0.000,-4.962) mag= 35.533943
  CameraLook = (-0.140,0.000,0.990) angle= 90.000000
  CameraRight= (-0.990,0.000,-0.140) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.132,0.000,0.991) angle= 90.461908
  RootRight  = (-0.991,0.000,-0.132) dot= 0.999968
  Wish(root basis): Right= 0.999968 Forward= -0.008062
  HumMove    = (-0.794,0.000,0.608) angle= 45.462369

ACCEL #245 t=3.1474 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-795.243,0.000,4335.405) mag= 4407.737305
  WishDir    = (-0.987,0.000,-0.164) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008288
  Dot(Vel,Wish) = 75.339050
  addSpeed = 106.660950
  accelSpeed(x10) = 2745.413605
  expectedAdd = 106.660950
  RETURN     = (-900.467,0.000,4317.958)
  DELTA      = (-105.224,0.000,-17.448) mag= 106.660927
  CameraLook = (-0.164,0.000,0.987) angle= 89.999999
  CameraRight= (-0.987,0.000,-0.164) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.140,0.000,0.990) angle= 91.386839
  RootRight  = (-0.990,0.000,-0.140) dot= 0.999707
  Wish(root basis): Right= 0.999707 Forward= -0.024203
  HumMove    = (-0.799,0.000,0.601) angle= 46.387096

ACCEL #246 t=3.1557 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-900.467,0.000,4317.958) mag= 4410.850098
  WishDir    = (-0.984,0.000,-0.181) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008344
  Dot(Vel,Wish) = 105.766907
  addSpeed = 76.233093
  accelSpeed(x10) = 2763.894084
  expectedAdd = 76.233093
  RETURN     = (-975.446,0.000,4304.188)
  DELTA      = (-74.979,0.000,-13.769) mag= 76.233147
  CameraLook = (-0.181,0.000,0.984) angle= 90.000000
  CameraRight= (-0.984,0.000,-0.181) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.164,0.000,0.987) angle= 90.990259
  RootRight  = (-0.987,0.000,-0.164) dot= 0.999851
  Wish(root basis): Right= 0.999851 Forward= -0.017282
  HumMove    = (-0.813,0.000,0.582) angle= 45.990787

ACCEL #247 t=3.1642 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-975.446,0.000,4304.188) mag= 4413.335938
  WishDir    = (-0.981,0.000,-0.192) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008326
  Dot(Vel,Wish) = 131.153137
  addSpeed = 50.846863
  accelSpeed(x10) = 2757.780095
  expectedAdd = 50.846863
  RETURN     = (-1025.348,0.000,4294.429)
  DELTA      = (-49.901,0.000,-9.760) mag= 50.846943
  CameraLook = (-0.192,0.000,0.981) angle= 90.000000
  CameraRight= (-0.981,0.000,-0.192) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.181,0.000,0.984) angle= 90.660062
  RootRight  = (-0.984,0.000,-0.181) dot= 0.999934
  Wish(root basis): Right= 0.999934 Forward= -0.011520
  HumMove    = (-0.823,0.000,0.568) angle= 45.660525

ACCEL #248 t=3.1727 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-1025.348,0.000,4294.429) mag= 4415.139648
  WishDir    = (-0.979,0.000,-0.203) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008348
  Dot(Vel,Wish) = 131.132507
  addSpeed = 50.867493
  accelSpeed(x10) = 2765.260392
  expectedAdd = 50.867493
  RETURN     = (-1075.154,0.000,4284.090)
  DELTA      = (-49.806,0.000,-10.338) mag= 50.867458
  CameraLook = (-0.203,0.000,0.979) angle= 89.999999
  CameraRight= (-0.979,0.000,-0.203) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.192,0.000,0.981) angle= 90.660194
  RootRight  = (-0.981,0.000,-0.192) dot= 0.999934
  Wish(root basis): Right= 0.999934 Forward= -0.011522
  HumMove    = (-0.830,0.000,0.558) angle= 45.660535

ACCEL #249 t=3.1814 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-1075.154,0.000,4284.090) mag= 4416.942871
  WishDir    = (-0.977,0.000,-0.215) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008919
  Dot(Vel,Wish) = 131.111572
  addSpeed = 50.888428
  accelSpeed(x10) = 2954.315885
  expectedAdd = 50.888428
  RETURN     = (-1124.857,0.000,4273.174)
  DELTA      = (-49.704,0.000,-10.917) mag= 50.888424
  CameraLook = (-0.215,0.000,0.977) angle= 90.000000
  CameraRight= (-0.977,0.000,-0.215) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.203,0.000,0.979) angle= 90.660234
  RootRight  = (-0.979,0.000,-0.203) dot= 0.999934
  Wish(root basis): Right= 0.999934 Forward= -0.011523
  HumMove    = (-0.836,0.000,0.549) angle= 45.660530

ACCEL #250 t=3.1892 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-1124.857,0.000,4273.174) mag= 4418.746094
  WishDir    = (-0.974,0.000,-0.227) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.007798
  Dot(Vel,Wish) = 125.999207
  addSpeed = 56.000793
  accelSpeed(x10) = 2582.981989
  expectedAdd = 56.000793
  RETURN     = (-1179.398,0.000,4260.468)
  DELTA      = (-54.540,0.000,-12.706) mag= 56.000778
  CameraLook = (-0.227,0.000,0.974) angle= 90.000000
  CameraRight= (-0.974,0.000,-0.227) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.215,0.000,0.977) angle= 90.726288
  RootRight  = (-0.977,0.000,-0.215) dot= 0.999920
  Wish(root basis): Right= 0.999920 Forward= -0.012676
  HumMove    = (-0.842,0.000,0.539) angle= 45.726583

ACCEL #251 t=3.1977 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-1179.398,0.000,4260.468) mag= 4420.697754
  WishDir    = (-0.971,0.000,-0.240) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008337
  Dot(Vel,Wish) = 120.880493
  addSpeed = 61.119507
  accelSpeed(x10) = 2761.520243
  expectedAdd = 61.119507
  RETURN     = (-1238.726,0.000,4245.779)
  DELTA      = (-59.328,0.000,-14.689) mag= 61.119606
  CameraLook = (-0.240,0.000,0.971) angle= 90.000000
  CameraRight= (-0.971,0.000,-0.240) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= 0.000000
  RootLook   = (-0.227,0.000,0.974) angle= 90.792308
  RootRight  = (-0.974,0.000,-0.227) dot= 0.999904
  Wish(root basis): Right= 0.999904 Forward= -0.013828
  HumMove    = (-0.849,0.000,0.528) angle= 45.792623

ACCEL #252 t=3.2058 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-1238.726,0.000,4245.779) mag= 4422.791016
  WishDir    = (-0.969,0.000,-0.246) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008261
  Dot(Vel,Wish) = 156.524780
  addSpeed = 25.475220
  accelSpeed(x10) = 2736.249562
  expectedAdd = 25.475220
  RETURN     = (-1263.419,0.000,4239.514)
  DELTA      = (-24.693,0.000,-6.265) mag= 25.475279
  CameraLook = (-0.246,0.000,0.969) angle= 90.000001
  CameraRight= (-0.969,0.000,-0.246) dot= 1.000000
  Wish(cam basis): Right= 1.000000 Forward= -0.000000
  RootLook   = (-0.240,0.000,0.971) angle= 90.329946
  RootRight  = (-0.971,0.000,-0.240) dot= 0.999983
  Wish(root basis): Right= 0.999983 Forward= -0.005759
  HumMove    = (-0.856,0.000,0.516) angle= 45.330265

ACCEL #253 t=3.2230 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-1263.419,0.000,4239.514) mag= 4423.765625
  WishDir    = (0.969,0.000,0.246) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008829
  Dot(Vel,Wish) = -182.000000
  addSpeed = 364.000000
  accelSpeed(x10) = 2924.366008
  expectedAdd = 364.000000
  RETURN     = (-979.964,0.000,4311.432)
  DELTA      = (283.455,0.000,71.918) mag= 292.436646
  CameraLook = (-0.246,0.000,0.969) angle= 89.999999
  CameraRight= (-0.969,0.000,-0.246) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.246,0.000,0.969) angle= 89.999994
  RootRight  = (-0.969,0.000,-0.246) dot= -1.000000
  Wish(root basis): Right= -1.000000 Forward= 0.000000
  HumMove    = (0.511,0.000,0.859) angle= 45.000001

ACCEL #254 t=3.2311 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-979.964,0.000,4311.432) mag= 4421.399902
  WishDir    = (0.969,0.000,0.246) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008221
  Dot(Vel,Wish) = 110.436584
  addSpeed = 71.563416
  accelSpeed(x10) = 2723.192977
  expectedAdd = 71.563416
  RETURN     = (-910.598,0.000,4329.032)
  DELTA      = (69.366,0.000,17.600) mag= 71.563431
  CameraLook = (-0.246,0.000,0.969) angle= 89.999999
  CameraRight= (-0.969,0.000,-0.246) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.246,0.000,0.969) angle= 89.998620
  RootRight  = (-0.969,0.000,-0.246) dot= -1.000000
  Wish(root basis): Right= -1.000000 Forward= 0.000024
  HumMove    = (0.511,0.000,0.859) angle= 45.000001

ACCEL #255 t=3.2395 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-910.598,0.000,4329.032) mag= 4423.765625
  WishDir    = (0.969,0.000,0.246) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008023
  Dot(Vel,Wish) = 182.000061
  addSpeed = -0.000061
  accelSpeed(x10) = 2657.455643
  expectedAdd = 0.000000
  RETURN     = (-910.598,0.000,4329.032)
  DELTA      = (0.000,0.000,0.000) mag= 0.000000
  CameraLook = (-0.246,0.000,0.969) angle= 89.999999
  CameraRight= (-0.969,0.000,-0.246) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.246,0.000,0.969) angle= 89.998884
  RootRight  = (-0.969,0.000,-0.246) dot= -1.000000
  Wish(root basis): Right= -1.000000 Forward= 0.000019
  HumMove    = (0.511,0.000,0.859) angle= 45.000001

ACCEL #256 t=3.2476 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-910.598,0.000,4329.032) mag= 4423.765625
  WishDir    = (0.970,0.000,0.245) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008326
  Dot(Vel,Wish) = 176.904663
  addSpeed = 5.095337
  accelSpeed(x10) = 2758.069768
  expectedAdd = 5.095337
  RETURN     = (-905.658,0.000,4330.279)
  DELTA      = (4.940,0.000,1.248) mag= 5.095394
  CameraLook = (-0.245,0.000,0.970) angle= 90.000000
  CameraRight= (-0.970,0.000,-0.245) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.246,0.000,0.969) angle= 90.065881
  RootRight  = (-0.969,0.000,-0.246) dot= -0.999999
  Wish(root basis): Right= -0.999999 Forward= -0.001150
  HumMove    = (0.511,0.000,0.859) angle= 45.066047

ACCEL #257 t=3.2558 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-905.658,0.000,4330.279) mag= 4423.972656
  WishDir    = (0.972,0.000,0.235) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008293
  Dot(Vel,Wish) = 136.129089
  addSpeed = 45.870911
  accelSpeed(x10) = 2747.056012
  expectedAdd = 45.870911
  RETURN     = (-861.068,0.000,4341.047)
  DELTA      = (44.589,0.000,10.768) mag= 45.870911
  CameraLook = (-0.235,0.000,0.972) angle= 90.000000
  CameraRight= (-0.972,0.000,-0.235) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.245,0.000,0.970) angle= 90.594214
  RootRight  = (-0.970,0.000,-0.245) dot= -0.999946
  Wish(root basis): Right= -0.999946 Forward= -0.010371
  HumMove    = (0.512,0.000,0.859) angle= 45.594465

ACCEL #258 t=3.2642 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-861.068,0.000,4341.047) mag= 4425.621582
  WishDir    = (0.975,0.000,0.220) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008369
  Dot(Vel,Wish) = 115.711426
  addSpeed = 66.288574
  accelSpeed(x10) = 2772.106122
  expectedAdd = 66.288574
  RETURN     = (-796.406,0.000,4355.640)
  DELTA      = (64.662,0.000,14.593) mag= 66.288635
  CameraLook = (-0.220,0.000,0.975) angle= 90.000000
  CameraRight= (-0.975,0.000,-0.220) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.235,0.000,0.972) angle= 90.858316
  RootRight  = (-0.972,0.000,-0.235) dot= -0.999888
  Wish(root basis): Right= -0.999888 Forward= -0.014980
  HumMove    = (0.521,0.000,0.853) angle= 45.858690

ACCEL #259 t=3.2725 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-796.406,0.000,4355.640) mag= 4427.851074
  WishDir    = (0.980,0.000,0.200) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008327
  Dot(Vel,Wish) = 90.162781
  addSpeed = 91.837219
  accelSpeed(x10) = 2758.111415
  expectedAdd = 91.837219
  RETURN     = (-706.422,0.000,4373.994)
  DELTA      = (89.984,0.000,18.354) mag= 91.837181
  CameraLook = (-0.200,0.000,0.980) angle= 90.000000
  CameraRight= (-0.980,0.000,-0.200) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= 0.000000
  RootLook   = (-0.220,0.000,0.975) angle= 91.188434
  RootRight  = (-0.975,0.000,-0.220) dot= -0.999785
  Wish(root basis): Right= -0.999785 Forward= -0.020741
  HumMove    = (0.534,0.000,0.845) angle= 46.188934

ACCEL #260 t=3.2809 state=Enum.HumanoidStateType.Freefall callerLine=305
  callerSource = =Opiumware
  Velocity   = (-706.422,0.000,4373.994) mag= 4430.672363
  WishDir    = (0.984,0.000,0.177) mag= 1.000000
  Accel      = 182.000000
  WishSpeed  = 182.000000
  dt         = 0.008280
  Dot(Vel,Wish) = 79.889954
  addSpeed = 102.110046
  accelSpeed(x10) = 2742.736209
  expectedAdd = 102.110046
  RETURN     = (-605.928,0.000,4392.089)
  DELTA      = (100.494,0.000,18.095) mag= 102.110039
  CameraLook = (-0.177,0.000,0.984) angle= 90.000001
  CameraRight= (-0.984,0.000,-0.177) dot= -1.000000
  Wish(cam basis): Right= -1.000000 Forward= -0.000000
  RootLook   = (-0.200,0.000,0.980) angle= 91.320373
  RootRight  = (-0.980,0.000,-0.200) dot= -0.999735
  Wish(root basis): Right= -0.999735 Forward= -0.023043
  HumMove    = (0.552,0.000,0.834) angle= 46.321052

            ) do

                if link.source
                    and link.source.Parent
                    and link.target
                    and link.target.Parent
                then

                    pcall(function()
                        link.target.CFrame =
                            link.source.CFrame
                    end)

                end

            end

        end

    end

    for _, link in ipairs(
        unusualRuntime.animationLinks
    ) do

        local sourceRootPart =
            link.sourceRoot

        local sourcePart =
            link.sourcePart

        local targetPart =
            link.targetPart

        if sourceRootPart
            and sourceRootPart.Parent
            and sourcePart
            and sourcePart.Parent
            and targetPart
            and targetPart.Parent
        then

            pcall(function()
                sourceRootPart.Transparency = 1
                sourceRootPart.LocalTransparencyModifier = 1
                sourcePart.Transparency = 1
                sourcePart.LocalTransparencyModifier = 1
            end)

            local relative =
                sourceRootPart.CFrame:ToObjectSpace(
                    sourcePart.CFrame
                )

            local anchor =
                link.anchor

            if anchor
                and anchor.Parent
                and anchor:IsA("BasePart")
            then
                pcall(function()
                    anchor.CFrame =
                        targetPart.CFrame *
                        relative
                end)
            end

        end

    end
end

--// =========================================================
--// CREATE LOCAL ANCHOR FOR NESTED BASEPART
--// =========================================================

local function createUnusualAnchor(
    sourceRoot,
    sourcePart,
    targetPart,
    id,
    index
)
    local anchor

    if sourcePart:IsA("MeshPart")
        or sourcePart:IsA("Part")
        or sourcePart:IsA("UnionOperation")
        or sourcePart:IsA("TrussPart")
    then

        local success =
            pcall(function()
                anchor =
                    sourcePart:Clone()
            end)

        if not success
            or not anchor
        then
            return nil
        end

        anchor.Name =
            "DeadEyeUnusualGeometry_" ..
            tostring(id) ..
            "_" ..
            tostring(index)

        for _, joint in ipairs(
            anchor:GetDescendants()
        ) do

            if joint:IsA("Weld")
                or joint:IsA("WeldConstraint")
                or joint:IsA("Motor6D")
                or joint:IsA("Motor")
                or joint:IsA("Script")
                or joint:IsA("LocalScript")
                or joint:IsA("ModuleScript")
            then

                pcall(function()
                    joint:Destroy()
                end)

            end

        end

        pcall(function()
            anchor.Anchored = false
            anchor.CanCollide = false
            anchor.CanTouch = false
            anchor.CanQuery = false
            anchor.Massless = true
            anchor.CastShadow = false
        end)

    else

        anchor =
            Instance.new("Part")

        anchor.Name =
            "DeadEyeUnusualAnchor_" ..
            tostring(id) ..
            "_" ..
            tostring(index)

        anchor.Size =
            Vector3.new(
                math.max(
                    sourcePart.Size.X,
                    0.05
                ),
                math.max(
                    sourcePart.Size.Y,
                    0.05
                ),
                math.max(
                    sourcePart.Size.Z,
                    0.05
                )
            )

        anchor.Transparency = 1
        anchor.CanCollide = false
        anchor.CanTouch = false
        anchor.CanQuery = false
        anchor.CastShadow = false
        anchor.Massless = true
        anchor.Anchored = false

    end

    local relative =
        sourceRoot.CFrame:ToObjectSpace(
            sourcePart.CFrame
        )

    anchor.CFrame =
        targetPart.CFrame *
        relative

    local parent =
        targetPart.Parent

    if not parent then
        pcall(function()
            anchor:Destroy()
        end)
        return nil
    end

    anchor.Parent =
        parent

    local weld =
        Instance.new("WeldConstraint")

    weld.Name =
        "DeadEyeUnusualWeld"

    weld.Part0 =
        targetPart

    weld.Part1 =
        anchor

    weld.Parent =
        anchor

    tagUnusualFX(
        anchor,
        id
    )

    return anchor
end

--// =========================================================
--// INSTALL ONE SOURCE PART
--// =========================================================

local function installUnusualPartFX(
    sourcePart,
    targetPart,
    id,
    animatedSource
)

    local targetMap = {}
    local sourceNodes = {}

    --// Root source part uses the real visual part.
    targetMap[sourcePart] =
        targetPart

    table.insert(
        sourceNodes,
        sourcePart
    )

    --// Complete nested visual models (for example
    --// CirclingEclipseCola.spins) are mirrored as a
    --// self-contained mini-rig. Their internal Motor6D/Weld
    --// chain remains on the hidden animated source.
    for _, child in ipairs(
        sourcePart:GetChildren()
    ) do

        if child:IsA("Model") then

            local hasNestedPart = false
            local hasAnimationDriver = false

            for _, object in ipairs(
                child:GetDescendants()
            ) do

                if object:IsA("BasePart") then
                    hasNestedPart = true
                end

                if object:IsA("Motor6D")
                    or object:IsA("AnimationController")
                    or object:IsA("Animator")
                    or object:IsA("Script")
                    or object:IsA("LocalScript")
                then
                    hasAnimationDriver = true
                end

            end

            local hasAnimationController = false
            local hasAnimation = false

            for _, object in ipairs(
                child:GetDescendants()
            ) do
                if object:IsA("AnimationController") then
                    hasAnimationController = true
                elseif object:IsA("Animation") then
                    hasAnimation = true
                end
            end

            if hasNestedPart
                and hasAnimationDriver
                and not (
                    hasAnimationController
                    and hasAnimation
                )
            then
                unusualRuntime.createVisualMirror(
                    child,
                    id
                )
            end

        end

    end

    --// Direct extra BaseParts are handled by the
    --// existing anchor path.
    local anchorIndex = 0

    for _, nested in ipairs(
        sourcePart:GetChildren()
    ) do

        if nested:IsA("BasePart")
        then

            anchorIndex += 1

            local anchor =
                createUnusualAnchor(
                    sourcePart,
                    nested,
                    targetPart,
                    id,
                    anchorIndex
                )

            if anchor then

                targetMap[nested] =
                    anchor

                local animated =
                    unusualRuntime.addAnimationLink(
                        sourcePart,
                        nested,
                        targetPart,
                        animatedSource
                    )

                if animated then
                    for _, child in ipairs(
                        anchor:GetChildren()
                    ) do
                        if child:IsA(
                            "WeldConstraint"
                        )
                        or child:IsA(
                            "Weld"
                        )
                        or child:IsA(
                            "Motor6D"
                        )
                        then
                            pcall(function()
                                child:Destroy()
                            end)
                        end
                    end

                    anchor.Anchored = true

                    unusualRuntime.animationLinks[
                        #unusualRuntime.animationLinks
                    ].anchor =
                        anchor
                end

                table.insert(
                    sourceNodes,
                    nested
                )

            end

        end

    end

    local attachmentMap = {}

    --// -----------------------------------------------------
    --// PASS 1:
    --// Clone all needed attachments and remember their mapping.
    --// -----------------------------------------------------

    for _, currentSourcePart in ipairs(
        sourceNodes
    ) do

        local currentTargetPart =
            targetMap[currentSourcePart]

        if currentTargetPart then

            local needed =
                getNeededUnusualAttachments(
                    currentSourcePart
                )

            for attachment in pairs(
                needed
            ) do

                local parent =
                    attachment.Parent

                if not (
                    parent
                    and parent:IsA("Attachment")
                    and needed[parent]
                ) then

                    local clone =
                        attachment:Clone()

                    --// Direct clone keeps the same local
                    --// CFrame because the parent type is identical.
                    clone.CFrame =
                        attachment.CFrame

                    clone.Parent =
                        currentTargetPart

                    tagUnusualFX(
                        clone,
                        id
                    )

                    mapUnusualAttachments(
                        attachment,
                        clone,
                        attachmentMap
                    )

                end

            end

        end

    end

    --// -----------------------------------------------------
    --// PASS 2:
    --// Clone FX in the correct nested-part space.
    --// -----------------------------------------------------

    for _, currentSourcePart in ipairs(
        sourceNodes
    ) do

        local currentTargetPart =
            targetMap[currentSourcePart]

        if currentTargetPart then

            for _, sourceObject in ipairs(
                currentSourcePart:GetDescendants()
            ) do

                if isUnusualFX(
                    sourceObject
                )
                and unusualObjectBelongsToPart(
                    sourceObject,
                    currentSourcePart
                )
                then

                    local insideAttachment =
                        false

                    local parent =
                        sourceObject.Parent

                    while parent
                        and parent ~= currentSourcePart
                    do

                        if parent:IsA(
                            "Attachment"
                        ) then

                            insideAttachment =
                                true

                            break

                        end

                        parent =
                            parent.Parent

                    end

                    if not insideAttachment then

                        local clone =
                            sourceObject:Clone()

                        if clone:IsA("Trail")
                            or clone:IsA("Beam")
                        then

                            if sourceObject.Attachment0 then

                                local newA0 =
                                    attachmentMap[
                                        sourceObject.Attachment0
                                    ]

                                if newA0 then
                                    clone.Attachment0 =
                                        newA0
                                end

                            end

                            if sourceObject.Attachment1 then

                                local newA1 =
                                    attachmentMap[
                                        sourceObject.Attachment1
                                    ]

                                if newA1 then
                                    clone.Attachment1 =
                                        newA1
                                end

                            end

                        end

                        clone.Parent =
                            currentTargetPart

                        tagUnusualFX(
                            clone,
                            id
                        )

                    end

                end

            end

        end

    end

end

--// =========================================================
--// APPLY UNUSUAL FX ONLY
--// =========================================================

local function applyUnusualFX(
    id,
    visualRig,
    playerCharacter
)

    local cosmeticRig =
        getUnusualCosmeticRig(
            id,
            visualRig
        )

    if not cosmeticRig then

        warn(            "[UnusualSwapper] Cosmetic rig not found:",
            id
        )

        return false

    end

    --// Build the hidden animation source first. This cleanup
    --// routine destroys previous runtime/animated visuals,
    --// so the visible animated mini-rig must be installed after it.
    local animatedSource =
        unusualRuntime.createAnimationSource(
            cosmeticRig,
            id,
            playerCharacter
        )

    local animatedNestedInstalled =
        unusualRuntime.installAnimatedNestedModels(
            cosmeticRig,
            id,
            visualRig,
            playerCharacter
        )

    local installed =
        0

    if animatedNestedInstalled > 0 then
        installed += animatedNestedInstalled
        print(
            "[UnusualSwapper] Animated nested models:",
            animatedNestedInstalled,
            "ID:",
            id
        )
    end

    for _, sourcePart in ipairs(
        cosmeticRig:GetChildren()
    ) do

        if sourcePart:IsA(
            "BasePart"
        ) then

            local targetPart

            if sourcePart.Name
                == "HumanoidRootPart"
            then

                if playerCharacter then

                    targetPart =
                        playerCharacter:FindFirstChild(
                            "HumanoidRootPart"
                        )

                end

                if not targetPart then

                    targetPart =
                        visualRig:FindFirstChild(
                            "HumanoidRootPart"
                        )

                end

            else

                targetPart =
                    visualRig:FindFirstChild(
                        sourcePart.Name
                    )

            end

            if targetPart
                and targetPart:IsA(
                    "BasePart"
                )
            then

                installUnusualPartFX(
                    sourcePart,
                    targetPart,
                    id,
                    animatedSource
                )

                installed += 1

            end

        end

    end

    print(
        "[UnusualSwapper] Installed FX on",
        installed,
        "parts"
    )

    return installed > 0

end

--// =========================================================
--// REMOVE OUR FX
-- =========================================================
local function removeOurUnusualFX()
    unusualRuntime.destroyAnimationSource()

    local removed = 0
    local roots = {
        getUnusualVisualRig(),
        getUnusualPlayerCharacter()
    }
    local seen = {}
    for _, root in ipairs(
        roots
    ) do
        if root
            and not seen[root]
        then
            seen[root] =
                true
            for _, object in ipairs(
                root:GetDescendants()
            ) do
                local marked =
                    false
                pcall(function()
                    marked =
                        object:GetAttribute(
                            "DeadEyeUnusualFX"
                        ) == true
                end)
                if marked then
                    pcall(function()
                        object:Destroy()
                        removed += 1
                    end)
                end
            end
        end
    end
    if removed > 0 then
            end
end
--// =========================================================
--// CHECK OUR INSTALLED FX
--// =========================================================
local function hasOurUnusualFX(
    root,
    id
)
    if not root then
        return false
    end

    local wanted =
        tonumber(id)

    for _, object in ipairs(
        root:GetDescendants()
    ) do
        local marked = false
        local fxId = nil

        pcall(function()
            marked =
                object:GetAttribute(
                    "DeadEyeUnusualFX"
                ) == true

            fxId =
                tonumber(
                    object:GetAttribute(
                        "DeadEyeUnusualFXID"
                    )
                )
        end)

        if marked
            and fxId
            and wanted
            and fxId == wanted
        then
            return true
        end
    end

    return false
end

--// =========================================================
--// ORIGINAL SIGNATURE
-- =========================================================
local function buildOriginalUnusualSignature(
    id,
    visualRig
)
    local cosmeticRig =
        getUnusualCosmeticRig(
            id,
            visualRig
        )

    if not cosmeticRig then
        return nil
    end

    local signature = {}

    local function hasEffectContent(
        object
    )
        if isUnusualFX(object) then
            return true
        end

        if object:IsA("BasePart") then
            return true
        end

        for _, descendant in ipairs(
            object:GetDescendants()
        ) do
            if isUnusualFX(descendant)
                or descendant:IsA("BasePart")
            then
                return true
            end
        end

        return false
    end

    for _, sourcePart in ipairs(
        cosmeticRig:GetChildren()
    ) do

        if sourcePart:IsA("BasePart") then

            local objects = {}

            for _, object in ipairs(
                sourcePart:GetChildren()
            ) do

                if (
                    object:IsA("Weld")
                    or object:IsA("WeldConstraint")
                    or object:IsA("Motor6D")
                    or object:IsA("Motor")
                    or object:IsA("CFrameValue")
                ) then

                    continue

                end

                if hasEffectContent(object) then

                    local info = {
                        Class =
                            object.ClassName,
                        Name =
                            object.Name
                    }

                    if object:IsA("MeshPart") then
                        info.MeshId =
                            tostring(object.MeshId)
                        info.TextureId =
                            tostring(object.TextureID)
                    end

                    table.insert(
                        objects,
                        info
                    )

                end

            end

            signature[
                sourcePart.Name
            ] = objects

        end

    end

    return signature
end

--// =========================================================
--// REMOVE ORIGINAL FX
-- =========================================================
local function removeOriginalUnusualFX(
    id,
    visualRig,
    playerCharacter
)
    local signature =
        buildOriginalUnusualSignature(
            id,
            visualRig
        )

    if not signature then
        return
    end

    for partName, objects in pairs(
        signature
    ) do

        local targetPart

        if partName
            == "HumanoidRootPart"
        then

            if playerCharacter then
                targetPart =
                    playerCharacter:FindFirstChild(
                        "HumanoidRootPart"
                    )
            end

        else

            targetPart =
                visualRig:FindFirstChild(
                    partName
                )

        end

        if targetPart
            and targetPart:IsA("BasePart")
        then

            for _, existing in ipairs(
                targetPart:GetChildren()
            ) do

                for _, info in ipairs(
                    objects
                ) do

                    local match = false

                    if existing.ClassName ==
                        info.Class
                    then

                        if existing:IsA("MeshPart")
                            and info.MeshId
                        then

                            match =
                                existing.Name ==
                                info.Name
                                and tostring(existing.MeshId)
                                    == info.MeshId
                                and tostring(existing.TextureID)
                                    == info.TextureId

                        else

                            match =
                                existing.Name ==
                                info.Name

                        end

                    end

                    if match then

                        pcall(function()
                            existing:Destroy()
                        end)

                        for _, joint in ipairs(
                            targetPart:GetChildren()
                        ) do

                            if (
                                joint:IsA("Weld")
                                or joint:IsA("WeldConstraint")
                                or joint:IsA("Motor6D")
                                or joint:IsA("Motor")
                            )
                            and joint.Name ==
                                info.Name
                            then

                                pcall(function()
                                    joint:Destroy()
                                end)

                            end

                        end

                        break

                    end

                end

            end

            --// Remove matching original joints such as
            --// CatRadiance Head.Ears / Head.Bigotes.
            for _, joint in ipairs(
                targetPart:GetChildren()
            ) do

                if joint:IsA("Weld")
                    or joint:IsA("WeldConstraint")
                    or joint:IsA("Motor6D")
                    or joint:IsA("Motor")
                then

                    for _, info in ipairs(
                        objects
                    ) do

                        if joint.Name ==
                            info.Name
                        then

                            pcall(function()
                                joint:Destroy()
                            end)

                            break

                        end

                    end

                end

            end

        end

    end

    --// Non-body-root original effect objects.
    for _, child in ipairs(
        visualRig:GetChildren()
    ) do

        local matched =
            false

        for partName in pairs(signature) do
            if child.Name ==
                partName
            then
                matched = true
                break
            end
        end

        if not matched then
            --// Do not touch the player's actual body parts.
            if child:GetAttribute(
                "DeadEyeUnusualFXID"
            ) then

                pcall(function()
                    child:Destroy()
                end)

            end

        end

    end

end

--// =========================================================
--// RESTORE UNUSUAL
-- =========================================================
local function restoreUnusual()
    if not unusualActive then
        return
    end
    local visualRig =
        getUnusualVisualRig()
    local playerCharacter =
        getUnusualPlayerCharacter()
    if visualRig
        and unusualSlot.originalId
    then
        removeOurUnusualFX()
        task.wait()
        applyUnusualFX(
            unusualSlot.originalId,
            visualRig,
            playerCharacter
        )
    end
    unusualActive =
        false
    unusualRuntime.appliedRig =
        nil
end
--// =========================================================
--// ACTIVATE UNUSUAL
-- =========================================================
local function activateUnusual()
    if not unusualSlot.originalId
        or not unusualSlot.replaceId
    then
        return false
    end
    if unusualSlot.originalId
        == unusualSlot.replaceId
    then
        return false
    end
    local visualRig =
        getUnusualVisualRig()
    local playerCharacter =
        getUnusualPlayerCharacter()
    if not visualRig then
        return false
    end
                            removeOurUnusualFX()
    task.wait()
    removeOriginalUnusualFX(
        unusualSlot.originalId,
        visualRig,
        playerCharacter
    )
    task.wait()
    if not applyUnusualFX(
        unusualSlot.replaceId,
        visualRig,
        playerCharacter
    ) then
        task.wait()
        applyUnusualFX(
            unusualSlot.originalId,
            visualRig,
            playerCharacter
        )
        return false
    end
    unusualActive =
        true
    unusualRuntime.appliedRig =
        visualRig
    return true
end
local function reapplyUnusual()
    if not unusualEnabled
        or unusualReapplyBusy
    then
        return
    end

    unusualReapplyBusy = true
    unusualRuntime.reapplyGeneration += 1

    local generation =
        unusualRuntime.reapplyGeneration

    task.spawn(function()

        for attempt = 1, 20 do

            if not unusualEnabled
                or genv.DEADEYE_UNUSUAL_POV_RUNNING == false
                or generation ~= unusualRuntime.reapplyGeneration
            then
                break
            end

            local visualRig =
                getUnusualVisualRig()

            local playerCharacter =
                getUnusualPlayerCharacter()

            local root =
                visualRig
                and visualRig:FindFirstChild(
                    "HumanoidRootPart"
                )

            local humanoid =
                visualRig
                and visualRig:FindFirstChildOfClass(
                    "Humanoid"
                )

            if visualRig
                and root
                and humanoid
            then

                task.wait(0.2)

                unusualActive = false
                removeOurUnusualFX()

                local ok, result =
                    pcall(function()
                        return activateUnusual()
                    end)

                if ok
                    and result == true
                then

                    local expected =
                        (
                            #unusualRuntime.animatedNestedVisuals > 0
                        )
                        or hasOurUnusualFX(
                            visualRig,
                            unusualSlot.replaceId
                        )
                        or hasOurUnusualFX(
                            playerCharacter,
                            unusualSlot.replaceId
                        )

                    if expected then
                        unusualRuntime.appliedRig =
                            visualRig
                        break
                    end

                end

            end

            task.wait(0.25)

        end

        unusualReapplyBusy = false

    end)
end
--// =========================================================
--// FIRST PERSON / VIEWMODEL SYNC
--//
--// 3P uses workspace.Rigs.<name>.
--// 1P uses workspace.Camera.Viewmodel.Clothing.
--// In 1P the game hides the 3P rig with LocalTransparencyModifier.
--// =========================================================
genv.DEADEYE_UNUSUAL_POV_RUNNING = true
local lastUnusualPOVState = nil
local function getUnusualViewmodel()
    local camera =
        workspace.CurrentCamera
    if not camera then
        return nil
    end
    local viewmodel =
        camera:FindFirstChild(
            "Viewmodel"
        )
    if not viewmodel then
        return nil
    end
    return viewmodel
end
local function isUnusualFirstPerson()
    local visualRig =
        getUnusualVisualRig()
    if not visualRig then
        return false
    end
    local bodyNames = {
        "Head",
        "Torso",
        "Left Arm",
        "Right Arm",
        "Left Leg",
        "Right Leg"
    }
    local total = 0
    local hidden = 0
    for _, name in ipairs(
        bodyNames
    ) do
        local part =
            visualRig:FindFirstChild(
                name
            )
        if part
            and part:IsA("BasePart")
        then
            total += 1
            if part.LocalTransparencyModifier
                >= 0.99
            then
                hidden += 1
            end
        end
    end
    if total > 0
        and hidden >= math.ceil(
            total * 0.5
        )
    then
        return true
    end
    --// Fallback only when the rig does not expose
    --// LocalTransparencyModifier yet.
    local camera =
        workspace.CurrentCamera
    local head =
        visualRig:FindFirstChild(
            "Head"
        )
    if camera
        and head
    then
        local distance =
            (
                camera.CFrame.Position
                - head.Position
            ).Magnitude
        if distance < 1.5 then
            return true
        end
    end
    return false
end
local function syncUnusualViewmodelAppearance()
    local visualRig =
        getUnusualVisualRig()
    if not visualRig then
        return
    end
    local viewmodel =
        getUnusualViewmodel()
    if not viewmodel then
        return
    end
    local clothing =
        viewmodel:FindFirstChild(
            "Clothing"
        )
    if not clothing then
        return
    end
    --// Shirt: the 1P viewmodel has its own shirt,
    --// and it was confirmed to contain the old skin.
    local sourceShirt =
        visualRig:FindFirstChildOfClass(
            "Shirt"
        )
    local targetShirt =
        clothing:FindFirstChildOfClass(
            "Shirt"
        )
    if sourceShirt
        and targetShirt
    then
        pcall(function()
            if targetShirt.ShirtTemplate
                ~= sourceShirt.ShirtTemplate
            then
                targetShirt.ShirtTemplate =
                    sourceShirt.ShirtTemplate
            end
        end)
    end
    --// Body colors.
    local sourceColors =
        visualRig:FindFirstChildOfClass(
            "BodyColors"
        )
    local targetColors =
        clothing:FindFirstChildOfClass(
            "BodyColors"
        )
    if sourceColors
        and targetColors
    then
        local properties = {
            "HeadColor3",
            "TorsoColor3",
            "LeftArmColor3",
            "RightArmColor3",
            "LeftLegColor3",
            "RightLegColor3"
        }
        for _, property in ipairs(
            properties
        ) do
            pcall(function()
                targetColors[property] =
                    sourceColors[property]
            end)
        end
    end
end
local function setUnusualFXForPOV(
    firstPerson
)
    local roots = {
        getUnusualVisualRig(),
        getUnusualPlayerCharacter()
    }
    local seen = {}
    for _, root in ipairs(
        roots
    ) do
        if root
            and not seen[root]
        then
            seen[root] =
                true
            for _, object in ipairs(
                root:GetDescendants()
            ) do
                local tagged =
                    false
                pcall(function()
                    tagged =
                        object:GetAttribute(
                            "DeadEyeUnusualFX"
                        ) == true
                end)
                if tagged then
                    --// Trail is always kept.
                    --// Every other supported FX is hidden in 1P.
                    if object:IsA("Trail") then
                        pcall(function()
                            object.Enabled =
                                true
                        end)
                    elseif object:IsA("ParticleEmitter")
                        or object:IsA("Beam")
                        or object:IsA("Sparkles")
                        or object:IsA("Fire")
                        or object:IsA("Smoke")
                        or object:IsA("Highlight")
                        or object:IsA("PointLight")
                        or object:IsA("SpotLight")
                        or object:IsA("SurfaceLight")
                        or object:IsA("BillboardGui")
                    then
                        pcall(function()
                            object.Enabled =
                                not firstPerson
                        end)
                    end
                end
            end
        end
    end
end
local function updateUnusualPOV()
    if not genv.DEADEYE_UNUSUAL_POV_RUNNING then
        return
    end
    syncUnusualViewmodelAppearance()
    local firstPerson =
        isUnusualFirstPerson()
    if firstPerson
        ~= lastUnusualPOVState
    then
        lastUnusualPOVState =
            firstPerson
        setUnusualFXForPOV(
            firstPerson
        )
    elseif unusualActive then
        --// Re-apply the state when the game recreates
        --// one of the tagged FX while staying in the same POV.
        setUnusualFXForPOV(
            firstPerson
        )
    end
end
addUnusualConnection(
    RunService.Heartbeat:Connect(
        function()

            if not genv.DEADEYE_UNUSUAL_POV_RUNNING then
                return
            end

            unusualRuntime.updateAnimatedParts()
            updateUnusualPOV()

            if unusualEnabled
                and not unusualReapplyBusy
            then

                local rig =
                    getUnusualVisualRig()

                if rig then

                    local expected =
                        (
                            #unusualRuntime.animatedNestedVisuals > 0
                        )
                        or hasOurUnusualFX(
                            rig,
                            unusualSlot.replaceId
                        )
                        or hasOurUnusualFX(
                            getUnusualPlayerCharacter(),
                            unusualSlot.replaceId
                        )

                    if unusualRuntime.appliedRig ~= rig
                        or not expected
                    then
                        reapplyUnusual()
                    end

                end

            end

        end
    )
)
--// =========================================================
--// UNUSUAL PAGE
--// =========================================================
unusualPage =
    Instance.new("ScrollingFrame")
unusualPage.Name =
    "UnusualPage"
unusualPage.Size =
    UDim2.new(
        1,
        -92,
        1,
        -56
    )
unusualPage.Position =
    UDim2.new(
        0,
        82,
        0,
        48
    )
unusualPage.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
unusualPage.BorderSizePixel =
    0
unusualPage.ScrollBarThickness =
    6
unusualPage.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
unusualPage.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
unusualPage.ScrollingDirection =
    Enum.ScrollingDirection.Y
unusualPage.Visible =
    false
unusualPage.Parent =
    Main
__UI.unusualPageCorner =
    Instance.new("UICorner")
__UI.unusualPageCorner.CornerRadius =
    UDim.new(
        0,
        9
    )
__UI.unusualPageCorner.Parent =
    unusualPagelocal unusualPadding =
    Instance.new("UIPadding")
unusualPadding.PaddingTop =
    UDim.new(
        0,
        8
    )
unusualPadding.PaddingBottom =
    UDim.new(
        0,
        8
    )
unusualPadding.PaddingLeft =
    UDim.new(
        0,
        8
    )
unusualPadding.PaddingRight =
    UDim.new(
        0,
        8
    )
unusualPadding.Parent =
    unusualPage
local unusualLayout =
    Instance.new("UIListLayout")
unusualLayout.Padding =
    UDim.new(
        0,
        7
    )
unusualLayout.SortOrder =
    Enum.SortOrder.LayoutOrder
unusualLayout.Parent =
    unusualPage
local unusualRow =
    Instance.new("Frame")
unusualRow.Size =
    UDim2.new(
        1,
        -4,
        0,
        48
    )
unusualRow.BackgroundColor3 =
    Color3.fromRGB(
        40,
        40,
        40
    )
unusualRow.BorderSizePixel =
    0
unusualRow.LayoutOrder =
    1
unusualRow.Parent =
    unusualPage
__UI.unusualRowCorner =
    Instance.new("UICorner")
__UI.unusualRowCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.unusualRowCorner.Parent =
    unusualRow
local unusualRowLabel =
    Instance.new("TextLabel")
unusualRowLabel.Size =
    UDim2.new(
        0,
        60,
        1,
        0
    )
unusualRowLabel.Position =
    UDim2.new(
        0,
        8,
        0,
        0
    )
unusualRowLabel.BackgroundTransparency =
    1
unusualRowLabel.Text =
    "UNUSUAL"
unusualRowLabel.TextSize =
    10
unusualRowLabel.Font =
    Enum.Font.GothamBold
unusualRowLabel.TextColor3 =
    Color3.fromRGB(
        210,
        210,
        210
    )
unusualRowLabel.TextXAlignment =
    Enum.TextXAlignment.Left
unusualRowLabel.Parent =
    unusualRow
--// ORIGINAL
unusualOriginalButton =
    Instance.new("TextButton")
unusualOriginalButton.Size =
    UDim2.new(
        0,
        125,
        0,
        32
    )
unusualOriginalButton.Position =
    UDim2.new(
        0,
        72,
        0.5,
        -16
    )
unusualOriginalButton.BackgroundColor3 =
    Color3.fromRGB(
        52,
        52,
        52
    )
unusualOriginalButton.BorderSizePixel =
    0
unusualOriginalButton.Text =
    unusualSlot.originalName
    or "Select"
unusualOriginalButton.TextSize =
    11
unusualOriginalButton.Font =
    Enum.Font.Gotham
unusualOriginalButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
unusualOriginalButton.TextTruncate =
    Enum.TextTruncate.AtEnd
unusualOriginalButton.Parent =
    unusualRow
__UI.unusualOriginalCorner =
    Instance.new("UICorner")
__UI.unusualOriginalCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.unusualOriginalCorner.Parent =
    unusualOriginalButton
--// ARROW
local unusualArrow =
    Instance.new("TextLabel")
unusualArrow.Size =
    UDim2.new(
        0,
        24,
        0,
        32
    )
unusualArrow.Position =
    UDim2.new(
        0,
        202,
        0.5,
        -16
    )
unusualArrow.BackgroundTransparency =
    1
unusualArrow.Text =
    "→"
unusualArrow.TextSize =
    22
unusualArrow.Font =
    Enum.Font.GothamBold
unusualArrow.TextColor3 =
    Color3.fromRGB(
        180,
        180,
        180
    )
unusualArrow.Parent =
    unusualRow
--// REPLACE
local unusualReplaceButton =
    Instance.new("TextButton")
unusualReplaceButton.Size =
    UDim2.new(
        0,
        125,
        0,
        32
    )
unusualReplaceButton.Position =
    UDim2.new(
        0,
        226,
        0.5,
        -16
    )
unusualReplaceButton.BackgroundColor3 =
    Color3.fromRGB(
        52,
        52,
        52
    )
unusualReplaceButton.BorderSizePixel =
    0
unusualReplaceButton.Text =
    unusualSlot.replaceName
    or "NONE"
unusualReplaceButton.TextSize =
    11
unusualReplaceButton.Font =
    Enum.Font.Gotham
unusualReplaceButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
unusualReplaceButton.TextTruncate =
    Enum.TextTruncate.AtEnd
unusualReplaceButton.Parent =
    unusualRow
__UI.unusualReplaceCorner =
    Instance.new("UICorner")
__UI.unusualReplaceCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.unusualReplaceCorner.Parent =
    unusualReplaceButton
--// =========================================================
--// UNUSUAL PICKER
-- =========================================================
unusualPicker =
    Instance.new("Frame")
unusualPicker.Size =
    UDim2.new(
        0,
        560,
        0,
        450
    )
unusualPicker.Position =
    UDim2.new(
        0.5,
        -280,
        0.5,
        -225
    )
unusualPicker.BackgroundColor3 =
    Color3.fromRGB(
        31,
        35,
        42
    )
unusualPicker.BackgroundTransparency =
    0.10
unusualPicker.BorderSizePixel =
    0
unusualPicker.ClipsDescendants =
    true
unusualPicker.Visible =
    false
unusualPicker.ZIndex =
    30
unusualPicker.Parent =
    ScreenGui
__UI.unusualPickerCorner =
    Instance.new("UICorner")
__UI.unusualPickerCorner.CornerRadius =
    UDim.new(
        0,
        8
    )
__UI.unusualPickerCorner.Parent =
    unusualPicker
__UI.unusualPickerStroke =
    Instance.new("UIStroke")
__UI.unusualPickerStroke.Thickness =
    1
__UI.unusualPickerStroke.Transparency =
    0.66
__UI.unusualPickerStroke.Parent =
    unusualPicker

__UI.unusualPickerGlass =
    Instance.new("UIGradient")
__UI.unusualPickerGlass.Rotation =
    115
__UI.unusualPickerGlass.Color =
    ColorSequence.new({
        ColorSequenceKeypoint.new(
            0,
            Color3.fromRGB(
                55,
                61,
                72
            )
        ),
        ColorSequenceKeypoint.new(
            0.42,
            Color3.fromRGB(
                38,
                43,
                51
            )
        ),
        ColorSequenceKeypoint.new(
            1,
            Color3.fromRGB(
                24,
                28,
                34
            )
        )
    })
__UI.unusualPickerGlass.Transparency =
    NumberSequence.new(0.20)
__UI.unusualPickerGlass.Parent =
    unusualPicker

unusualPickerTitle =
    Instance.new("TextLabel")
unusualPickerTitle.Size =
    UDim2.new(
        1,
        -45,
        0,
        32
    )
unusualPickerTitle.Position =
    UDim2.new(
        0,
        12,
        0,
        2
    )
unusualPickerTitle.BackgroundTransparency =
    1
unusualPickerTitle.Text =
    "Unusual Selector"
unusualPickerTitle.TextSize =
    16
unusualPickerTitle.Font =
    Enum.Font.GothamBold
unusualPickerTitle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
unusualPickerTitle.TextXAlignment =
    Enum.TextXAlignment.Left
unusualPickerTitle.ZIndex =
    31
unusualPickerTitle.Parent =
    unusualPicker
unusualPickerClose =
    Instance.new("TextButton")
unusualPickerClose.Size =
    UDim2.new(
        0,
        30,
        0,
        30
    )
unusualPickerClose.Position =
    UDim2.new(
        1,
        -35,
        0,
        4
    )
unusualPickerClose.BackgroundTransparency =
    1
unusualPickerClose.Text =
    "×"
unusualPickerClose.TextSize =
    25
unusualPickerClose.Font =
    Enum.Font.GothamBold
unusualPickerClose.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
unusualPickerClose.ZIndex =
    31
unusualPickerClose.Parent =
    unusualPicker
unusualPickerSearch =
    Instance.new("TextBox")
unusualPickerSearch.Size =
    UDim2.new(
        1,
        -20,
        0,
        30
    )
unusualPickerSearch.Position =
    UDim2.new(
        0,
        10,
        0,
        36
    )
unusualPickerSearch.BackgroundColor3 =
    Color3.fromRGB(
        40,
        45,
        53
    )
unusualPickerSearch.BackgroundTransparency =
    0.20
unusualPickerSearch.BorderSizePixel =
    0
unusualPickerSearch.ClearTextOnFocus =
    false
unusualPickerSearch.PlaceholderText =
    "Search by name or ID..."
unusualPickerSearch.PlaceholderColor3 =
    Color3.fromRGB(
        120,
        120,
        120
    )
unusualPickerSearch.Text =
    ""
unusualPickerSearch.TextSize =
    12
unusualPickerSearch.Font =
    Enum.Font.Gotham
unusualPickerSearch.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
unusualPickerSearch.ZIndex =
    32
unusualPickerSearch.Parent =
    unusualPicker
__UI.unusualSearchCorner =
    Instance.new("UICorner")
__UI.unusualSearchCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
__UI.unusualSearchCorner.Parent =
    unusualPickerSearch
unusualPickerScroll =
    Instance.new("ScrollingFrame")
unusualPickerScroll.Size =
    UDim2.new(
        1,
        -16,
        1,
        -74
    )
unusualPickerScroll.Position =
    UDim2.new(
        0,
        8,
        0,
        70
    )
unusualPickerScroll.BackgroundColor3 =
    Color3.fromRGB(
        32,
        35,
        42
    )
unusualPickerScroll.BackgroundTransparency =
    0.20
unusualPickerScroll.BorderSizePixel =
    0
unusualPickerScroll.ScrollBarThickness =
    6
unusualPickerScroll.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
unusualPickerScroll.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
unusualPickerScroll.ZIndex =
    31
unusualPickerScroll.Parent =
    unusualPicker
__UI.unusualPickerScrollCorner =
    Instance.new("UICorner")
__UI.unusualPickerScrollCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.unusualPickerScrollCorner.Parent =
    unusualPickerScroll
local unusualPickerPadding =
    Instance.new("UIPadding")
unusualPickerPadding.PaddingTop =
    UDim.new(0, 8)
unusualPickerPadding.PaddingBottom =
    UDim.new(0, 8)
unusualPickerPadding.PaddingLeft =
    UDim.new(0, 8)
unusualPickerPadding.PaddingRight =
    UDim.new(0, 8)
unusualPickerPadding.Parent =
    unusualPickerScroll
local unusualPickerGrid =
    Instance.new("UIGridLayout")
unusualPickerGrid.CellSize =
    UDim2.new(
        0,
        170,
        0,
        92
    )
unusualPickerGrid.CellPadding =
    UDim2.new(
        0,
        6,
        0,
        8
    )
unusualPickerGrid.SortOrder =
    Enum.SortOrder.LayoutOrder
unusualPickerGrid.Parent =
    unusualPickerScroll
--// =========================================================
--// REBUILD UNUSUAL PICKER
--// =========================================================
local function rebuildUnusualPicker()

    pcall(function()
        collectCurrentUnusualIcons(
            LocalPlayer:FindFirstChild(
                "PlayerGui"
            )
        )
    end)

    for _, button in ipairs(
        unusualPickerButtons
    ) do
        pcall(function()
            button:Destroy()
        end)
    end
    table.clear(
        unusualPickerButtons
    )
    local query =
        string.lower(
            unusualPickerSearch.Text
                or ""
        )
    local shown = 0

    do
        local button =
            Instance.new("TextButton")

        button.Name = "Unusual_None"
        button.BackgroundColor3 = Color3.fromRGB(55, 58, 68)
        button.BackgroundTransparency = 0.12
        button.BorderSizePixel = 0
        button.ClipsDescendants = true
        button.Text = "NONE"
        button.TextSize = 11
        button.Font = Enum.Font.GothamBold
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextTruncate = Enum.TextTruncate.AtEnd
        button.LayoutOrder = 0
        button.ZIndex = 32
        button.Parent = unusualPickerScroll

        local corner =
            Instance.new("UICorner")

        corner.CornerRadius =
            UDim.new(0, 5)
        corner.Parent = button

        table.insert(
            unusualPickerButtons,
            button
        )

        addUnusualConnection(
            button.MouseButton1Click:Connect(
                function()
                    if unusualPickerSide == "Original" then
                        unusualSlot.originalId = nil
                        unusualSlot.originalName = nil
                        unusualOriginalButton.Text = "Select"
                    elseif unusualPickerSide == "Replace" then
                        unusualSlot.replaceId = nil
                        unusualSlot.replaceName = nil
                        unusualReplaceButton.Text = "Select"
                    else
                        return
                    end

                    savedConfig.unusual = {
                        originalId = unusualSlot.originalId,
                        replaceId = unusualSlot.replaceId
                    }

                    saveSavedConfig()

                    if unusualEnabled then
                        unusualEnabled = false
                        genv.UNUSUAL_SWAPPER_ENABLED = false
                        restoreUnusual()
                        updateUnusualToggle()
                    end

                    unusualPicker.Visible = false
                    unusualPickerSide = nil
                end
            )
        )

        shown += 1
    end

    for index, data in ipairs(
        unusualList
    ) do
        local nameLower =
            string.lower(
                data.name
            )
        local idText =
            tostring(
                data.id
            )
        if query == ""
            or string.find(
                nameLower,
                query,
                1,
                true
            )
            or string.find(
                idText,
                query,
                1,
                true
            )
        then
            shown += 1
            local button =
                Instance.new(
                    "TextButton"
                )
            button.Name =
                "Unusual_"
                .. tostring(
                    data.id
                )
            button.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    50
                )
            button.BackgroundTransparency =
                0.05
            button.BorderSizePixel =
                0
            button.ClipsDescendants =
                true
            button.Text =
                ""
            button.TextSize =
                11
            button.Font =
                Enum.Font.Gotham
            button.TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )
            button.TextTruncate =
                Enum.TextTruncate.AtEnd
            button.LayoutOrder =
                index
            button.ZIndex =
                32
            button.Parent =
                unusualPickerScroll

            local icon =
                Instance.new("ImageLabel")
            icon.Name =
                "EffectIcon"
            icon.Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    0
                )
            icon.Position =
                UDim2.new(
                    0,
                    0,
                    0,
                    0
                )
            icon.BackgroundTransparency =
                1
            icon.BorderSizePixel =
                0
            icon.Visible =
                true
            icon.ImageTransparency =
                0
            icon.Active =
                false
            icon.Image =
                data.icon
                or unusualIconIdCache[
                    data.id
                ]
                or unusualIconCache[
                    normalizeUnusualIconKey(
                        data.name
                    )
                ]
                or ""
            icon.ScaleType =
                Enum.ScaleType.Crop
            icon.ZIndex =
                33
            icon.Parent =
                button

            local iconCorner =
                Instance.new("UICorner")
            iconCorner.CornerRadius =
                UDim.new(
                    0,
                    10
                )
            iconCorner.Parent =
                icon

            local glass =
                Instance.new("Frame")
            glass.Name =
                "GlassOverlay"
            glass.Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    0
                )
            glass.Position =
                UDim2.new(
                    0,
                    0,
                    0,
                    0
                )
            glass.BackgroundColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )
            glass.BackgroundTransparency =
                0.95
            glass.BorderSizePixel =
                0
            glass.ZIndex =
                34
            glass.Parent =
                button

            local glassCorner =
                Instance.new("UICorner")
            glassCorner.CornerRadius =
                UDim.new(
                    0,
                    10
                )
            glassCorner.Parent =
                glass

            local shade =
                Instance.new("Frame")
            shade.Name =
                "NameShade"
            shade.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    36
                )
            shade.Position =
                UDim2.new(
                    0,
                    0,
                    1,
                    -36
                )
            shade.BackgroundColor3 =
                Color3.fromRGB(
                    0,
                    0,
                    0
                )
            shade.BackgroundTransparency =
                0.42
            shade.BorderSizePixel =
                0
            shade.ZIndex =
                35
            shade.Parent =
                button

            local nameCorner =
                Instance.new("UICorner")
            nameCorner.CornerRadius =
                UDim.new(
                    0,
                    10
                )
            nameCorner.Parent =
                shade

            local nameLabel =
                Instance.new("TextLabel")
            nameLabel.Name =
                "EffectName"
            nameLabel.Size =
                UDim2.new(
                    1,
                    -12,
                    0,
                    30
                )
            nameLabel.Position =
                UDim2.new(
                    0,
                    6,
                    1,
                    -33
                )
            nameLabel.BackgroundTransparency =
                1
            nameLabel.BorderSizePixel =
                0
            nameLabel.Text =
                data.name
            nameLabel.TextSize =
                11
            nameLabel.Font =
                Enum.Font.GothamMedium
            nameLabel.TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )
            nameLabel.TextXAlignment =
                Enum.TextXAlignment.Left
            nameLabel.TextYAlignment =
                Enum.TextYAlignment.Center
            nameLabel.TextTruncate =
                Enum.TextTruncate.AtEnd
            nameLabel.ZIndex =
                36
            nameLabel.Parent =
                button

            local corner =
                Instance.new(
                    "UICorner"
                )
            corner.CornerRadius =
                UDim.new(
                    0,
                    7
                )
            corner.Parent =
                button
            table.insert(
                unusualPickerButtons,
                button
            )
            addUnusualConnection(
                button.MouseButton1Click:Connect(
                    function()
                        if unusualPickerSide
                            == "Original"
                        then
                            unusualSlot.originalId =
                                data.id
                            unusualSlot.originalName =
                                data.name
                            unusualOriginalButton.Text =
                                data.name
                        elseif unusualPickerSide
                            == "Replace"
                        then
                            unusualSlot.replaceId =
                                data.id
                            unusualSlot.replaceName =
                                data.name
                            unusualReplaceButton.Text =
                                data.name
                        end
                        savedConfig.unusual = {
                            originalId =
                                unusualSlot.originalId,
                            replaceId =
                                unusualSlot.replaceId
                        }
                        saveSavedConfig()
                        unusualPicker.Visible =
                            false
                        unusualPickerSide =
                            nil
                        if unusualEnabled then
                            task.spawn(
                                reapplyUnusual
                            )
                        end
                    end
                )
            )
        end
    end
    pcall(function()
        if unusualStatus then
            unusualStatus.Text =
                "Unusuals: "
                .. tostring(
                    #unusualList
                )
                .. " • "
                .. tostring(
                    shown
                )
                .. " found"
        end
    end)
    unusualPickerScroll.CanvasPosition =
        Vector2.new(
            0,
            0
        )
end
--// =========================================================
--// OPEN / CLOSE PICKER
-- =========================================================
local function openUnusualPicker(
    side
)
    unusualPickerSide =
        side

    if side == "Original" then
        unusualPickerTitle.Text =
            "Select Original"
    else
        unusualPickerTitle.Text =
            "Select Replacement"
    end

    unusualPickerSearch.Text =
        ""
    unusualPicker.Visible =
        true

    rebuildUnusualPicker()
end
local function closeUnusualPicker()
    unusualPicker.Visible =
        false
    unusualPickerSide =
        nil
end
addUnusualConnection(    unusualOriginalButton.MouseButton1Click:Connect(
        function()
            openUnusualPicker(
                "Original"
            )
        end
    )
)
addUnusualConnection(
    unusualReplaceButton.MouseButton1Click:Connect(
        function()
            openUnusualPicker(
                "Replace"
            )
        end
    )
)
addUnusualConnection(
    unusualPickerClose.MouseButton1Click:Connect(
        function()
            closeUnusualPicker()
        end
    )
)
addUnusualConnection(
    unusualPickerSearch:GetPropertyChangedSignal(
        "Text"
    ):Connect(
        function()
            if unusualPicker.Visible then
                rebuildUnusualPicker()
            end
        end
    )
)

addUnusualConnection(
    LocalPlayer:WaitForChild(
        "PlayerGui"
    ).DescendantAdded:Connect(
        function(obj)
            if obj:IsA("ImageLabel")
                and obj.Name == "IconIMG"
            then
                cacheUnusualIconFromObject(
                    obj
                )

                addUnusualConnection(
                    obj:GetPropertyChangedSignal(
                        "Image"
                    ):Connect(
                        function()
                            cacheUnusualIconFromObject(
                                obj
                            )
                        end
                    )
                )
            end
        end
    )
)

--// =========================================================
--// UNUSUAL STATUS + TOGGLE USE EXISTING GUI
-- =================================================
local unusualStatusText =
    Instance.new("TextLabel")
unusualStatusText.Name =
    "UnusualStatus"
unusualStatusText.Size =
    UDim2.new(
        0,
        260,
        0,
        20
    )
unusualStatusText.Position =
    UDim2.new(
        0,
        82,
        0,
        43
    )
unusualStatusText.BackgroundTransparency =
    1
unusualStatusText.Text =
    ""
unusualStatusText.TextSize =
    12
unusualStatusText.Font =
    Enum.Font.Gotham
unusualStatusText.TextColor3 =
    Color3.fromRGB(
        150,
        150,
        150
    )
unusualStatusText.TextXAlignment =
    Enum.TextXAlignment.Left
unusualStatusText.Visible =
    false
unusualStatusText.Parent =
    Main
unusualStatus =
    unusualStatusText
updateUnusualToggle = function()
    pcall(function()
        if unusualEnabled then
            Toggle.Text =
                "SWAP: ON"
            Toggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            Toggle.Text =
                "SWAP: OFF"
            Toggle.BackgroundColor3 =
                Color3.fromRGB(
                    47,
                    52,
                    61
                )
        end
    end)
end
--// =========================================================
--// OTHERS
--// R6 AVATAR SCANNER / EDITOR
--// =========================================================
function others.saveConfig()
    savedConfig.others =
        savedConfig.others
        or {}
    for _, slot in ipairs(
        others.ACCESSORY_SLOTS or {}
    ) do
        local box =
            others.fieldBoxes[
                slot.property
            ]
        if box then
            savedConfig.others[
                slot.property
            ] =
                tostring(
                    box.Text
                    or ""
                )
        end
    end
    for _, slot in ipairs(
        others.CLOTHING_SLOTS or {}
    ) do
        local box =
            others.fieldBoxes[
                slot.property
            ]
        if box then
            savedConfig.others[
                slot.property
            ] =
                tostring(
                    box.Text
                    or ""
                )
        end
    end
    for _, slot in ipairs(
        others.BODY_SLOTS or {}
    ) do
        local box =
            others.fieldBoxes[
                slot.property
            ]
        if box then
            savedConfig.others[
                slot.property
            ] =
                tostring(
                    box.Text
                    or ""
                )
        end
    end
    savedConfig.others._Headless =
        tostring(
            savedConfig.others._Headless
            or ""
        )
    savedConfig.others._Korblox =
        tostring(
            savedConfig.others._Korblox
            or ""
        )
    pcall(function()
        saveSavedConfig()
    end)
end
function others.loadConfig()
    local saved =
        savedConfig.others
    if type(saved) ~= "table" then
        return
    end
    for _, group in ipairs({
        others.ACCESSORY_SLOTS,
        others.CLOTHING_SLOTS,
        others.BODY_SLOTS
    }) do
        for _, slot in ipairs(
            group
        ) do
            local box =
                others.fieldBoxes[
                    slot.property
                ]
            local value =
                saved[
                    slot.property
                ]
            if box
                and value ~= nil
            then
                box.Text =
                    tostring(
                        value
                    )
            end
        end
    end
end
others.HEADLESS_ID = 134082579
others.KORBLOX_ID = 139607718
others.ACCESSORY_SLOTS = {
    {label = "Hats", property = "HatAccessory", multi = true},
    {label = "Hair", property = "HairAccessory", multi = true},
    {label = "Face Accessory", property = "FaceAccessory", multi = true},
    {label = "Neck", property = "NeckAccessory", multi = true},
    {label = "Shoulder", property = "ShouldersAccessory", multi = true},
    {label = "Front", property = "FrontAccessory", multi = true},
    {label = "Back", property = "BackAccessory", multi = true},
    {label = "Waist", property = "WaistAccessory", multi = true}
}
others.CLOTHING_SLOTS = {
    {label = "Shirt", property = "Shirt"},
    {label = "Pants", property = "Pants"},
    {label = "T-Shirt", property = "GraphicTShirt"}
}
others.BODY_SLOTS = {
    {label = "Head", property = "Head"},
    {label = "Torso", property = "Torso"},
    {label = "Left Arm", property = "LeftArm"},
    {label = "Right Arm", property = "RightArm"},
    {label = "Left Leg", property = "LeftLeg"},
    {label = "Right Leg", property = "RightLeg"}
}
others.ACCESSORY_PROPERTIES = {
    "HatAccessory",
    "HairAccessory",
    "FaceAccessory",
    "NeckAccessory",
    "ShouldersAccessory",
    "FrontAccessory",
    "BackAccessory",
    "WaistAccessory"
}
others.page = nil
others.status = nil
others.originalDescription = nil
others.targetHumanoid = nil
others.fieldBoxes = {}
function others.getHumanoids()
    local result = {}
    local seen = {}
    local function add(h)
        if h
            and h:IsA("Humanoid")
            and not seen[h]
        then
            seen[h] = true
            table.insert(result, h)
        end
    end
    local rig =
        getUnusualVisualRig()
    if rig then
        add(
            rig:FindFirstChildOfClass(
                "Humanoid"
            )
        )
    end
    local character =
        getUnusualPlayerCharacter()
    if character then
        add(
            character:FindFirstChildOfClass(
                "Humanoid"
            )
        )
    end
    return result
end
function others.getHumanoid()
    return others.getHumanoids()[1]
end
function others.ensureSnapshot()
    if others.originalDescription then
        return true
    end
    local humanoid =
        others.getHumanoid()
    if not humanoid then
        return false
    end
    local ok, description =
        pcall(function()
            return humanoid:GetAppliedDescription()
        end)
    if not ok or not description then
        return false
    end
    local cloneOk, clone =
        pcall(function()
            return description:Clone()
        end)
    if not cloneOk or not clone then
        return false
    end
    others.targetHumanoid =
        humanoid
    others.originalDescription =
        clone
    return true
end
function others.isR6()
    local humanoid =
        others.getHumanoid()
    return humanoid
        and humanoid.RigType
            == Enum.HumanoidRigType.R6
end
function others.getDescription()
    if not others.isR6() then
        if others.status then
            others.status.Text =
                "R6 only"
        end
        return nil
    end
    if not others.ensureSnapshot() then
        return nil
    end
    local humanoid =
        others.getHumanoid()
    if not humanoid then
        return nil
    end
    local ok, description =
        pcall(function()
            return humanoid:GetAppliedDescription()
        end)
    if ok and description then
        return description
    end
    return nil
end
function others.propertyText(
    description,
    slot
)
    local ok, value =
        pcall(function()
            return description[
                slot.property
            ]
        end)
    if not ok or value == nil then
        return ""
    end
    if slot.multi then
        return tostring(value or "")
    end
    local number =
        tonumber(value)
    if not number or number == 0 then
        return ""
    end
    return tostring(number)
end
function others.refresh()
    local description =
        others.getDescription()
    if not description then
        return
    end
    local groups = {
        others.ACCESSORY_SLOTS,
        others.CLOTHING_SLOTS,
        others.BODY_SLOTS
    }
    for _, group in ipairs(groups) do
        for _, slot in ipairs(group) do
            local box =
                others.fieldBoxes[
                    slot.property
                ]
            if box then
                box.Text =
                    others.propertyText(
                        description,
                        slot
                    )
            end
        end
    end
end
function others.applyDescription(
    description
)
    if not others.isR6() then
        if others.status then
            others.status.Text =
                "R6 only"
        end
        return false
    end
    local applied = 0
    local lastError
    for _, humanoid in ipairs(
        others.getHumanoids()
    ) do
        local ok, err =
            pcall(function()
                humanoid:ApplyDescriptionResetAsync(
                    description
                )
            end)
        if not ok then
            lastError =
                err
            local legacyOk, legacyErr =
                pcall(function()
                    humanoid:ApplyDescriptionReset(
                        description
                    )
                end)
            if legacyOk then
                ok = true
            else
                lastError = legacyErr
            end
        end
        if ok then
            applied += 1
        end
    end
    if applied == 0 then
        --// Last compatibility fallback.
        for _, humanoid in ipairs(
            others.getHumanoids()
        ) do
            local ok =
                pcall(function()
                    humanoid:ApplyDescriptionAsync(
                        description
                    )
                end)
            if ok then
                applied += 1
            end
        end
    end
    if applied == 0 then
        warn(
            "[Others] Apply failed:",
            lastError
        )
        if others.status then
            others.status.Text =
                "Apply Error"
        end
        return false
    end
    if others.status then
        others.status.Text =
            "Applied"
    end
    return true
end
function others.applyField(
    slot,
    textValue
)
    local description =
        others.getDescription()
    if not description then
        return false
    end
    local value
    if slot.multi then
        value =
            tostring(
                textValue or ""
            )
        value =
            string.gsub(
                value,
                "%s+",
                ""
            )
        value =
            string.gsub(
                value,
                "[^%d,]",
                ""
            )
        value =
            string.gsub(
                value,
                ",+",
                ","
            )
        value =
            string.gsub(
                value,
                "^,",
                ""
            )
        value =
            string.gsub(
                value,
                ",$",
                ""
            )
    else
        value =
            tonumber(
                string.match(
                    tostring(textValue or ""),
                    "%d+"
                )
            )
            or 0
    end
    local ok =
        pcall(function()
            description[
                slot.property
            ] = value
        end)
    if not ok then
        return false
    end
    return others.applyDescription(
        description
    )
end
function others.scan()
    local description =
        others.getDescription()
    if not description then
        return false
    end
    others.refresh()
    if others.status then
        others.status.Text =
            "Scanned • R6"
    end
    return true
end
function others.clearAccessories()
    local description =
        others.getDescription()
    if not description then
        return false
    end
    for _, property in ipairs(
        others.ACCESSORY_PROPERTIES
    ) do
        pcall(function()
            description[property] = ""
        end)
    end
    pcall(function()
        description.Face = 0
    end)
    return others.applyDescription(
        description
    )
end
function others.restore(
    keepSnapshot
)
    if not others.originalDescription then
        return false
    end
    local result =
        others.applyDescription(
            others.originalDescription
        )
    if not keepSnapshot then
        others.originalDescription =
            nil
        others.targetHumanoid =
            nil
    end
    return result
end
--// =========================================================
--// MAIN / AUTOJUMP
--// =========================================================
local mainJump = {
    enabled = false,
    jumpDelay = 0.01,
    hotkeyName = "Z",
    hideUIHotkeyName = "H",
    lastJump = 0,
    capturing = nil,
    character = nil,
    humanoid = nil,
    root = nil,
    sensorPart = nil,
    frontSensorPart = nil,
    sensorTouchConnection = nil,
    frontSensorTouchConnection = nil,
    connections = {}
}
mainJump.jumpDelay =
    math.clamp(
        tonumber(
            savedConfig.main
            and savedConfig.main.jumpDelay
        ) or 0.01,
        0,
        5
    )
mainJump.hotkeyName =
    tostring(
        savedConfig.main
        and savedConfig.main.hotkey
        or "Z"
    )
mainJump.hideUIHotkeyName =
    tostring(
        savedConfig.main
        and savedConfig.main.hideUIHotkey
        or "H"
    )
local function mainConnect(connection)
    table.insert(
        mainJump.connections,
        connection
    )
end
local function mainDisconnect()
    for _, connection in ipairs(
        mainJump.connections
    ) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    table.clear(
        mainJump.connections
    )
end
function mainJump.saveConfig()
    savedConfig.main = {
        jumpDelay = mainJump.jumpDelay,
        hotkey = mainJump.hotkeyName,
        hideUIHotkey =
            mainJump.hideUIHotkeyName
    }
    pcall(function()
        saveSavedConfig()
    end)
end
function mainJump.update()
    if not mainJump.toggle then
        return
    end
    if mainJump.enabled then
        mainJump.toggle.Text =
            "ON"
        mainJump.toggle.BackgroundColor3 =
            Color3.fromRGB(
                68,
                74,
                84
            )
    else
        mainJump.toggle.Text =
            "OFF"
        mainJump.toggle.BackgroundColor3 =
            Color3.fromRGB(
                47,
                52,
                61
            )
    end
end
function mainJump.setEnabled(state)
    mainJump.enabled =
        state and true or false

    if mainJump.enabled then
        if mainJump.character
            and mainJump.humanoid
            and mainJump.humanoid.Parent
        then
            pcall(function()
                mainJump.createSensors(
                    mainJump.character
                )
            end)

            task.defer(function()
                if not genv.DEADEYE_MAIN_RUNNING
                    or not mainJump.enabled
                    or not mainJump.humanoid
                    or not mainJump.humanoid.Parent
                then
                    return
                end
                if mainJump.canJump() then
                    mainJump.jump()
                end
            end)
        end
    else
        mainJump.destroySensors()

        if mainJump.humanoid
            and mainJump.humanoid.Parent
        then
            pcall(function()
                mainJump.humanoid.Jump = false
            end)

            task.defer(function()
                if mainJump.humanoid
                    and mainJump.humanoid.Parent
                then
                    pcall(function()
                        mainJump.humanoid.Jump = false
                    end)
                end
            end)
        end
    end

    mainJump.update()
end
function mainJump.setDelay(value)
    value =
        tonumber(
            tostring(value or "")
        )
    if not value then
        return
    end
    mainJump.jumpDelay =
        math.clamp(
            value,
            0,
            5
        )
    mainJump.delayBox.Text =
        tostring(
            mainJump.jumpDelay
        )
    mainJump.saveConfig()
end
local function mainFindKeyCode(value)
    local wanted =
        tostring(
            value or ""
        ):gsub(
            "%s+",
            ""
        ):lower()
    for _, keyCode in ipairs(
        Enum.KeyCode:GetEnumItems()
    ) do
        if keyCode.Name:lower() == wanted then
            return keyCode
        end
    end
    return nil
end
local jumpKey =
    mainFindKeyCode(
        mainJump.hotkeyName
    )
if jumpKey then
    mainJump.hotkeyName =
        jumpKey.Name
else
    mainJump.hotkeyName = "Z"
end
local hideKey =
    mainFindKeyCode(
        mainJump.hideUIHotkeyName
    )
if hideKey then
    mainJump.hideUIHotkeyName =
        hideKey.Name
else
    mainJump.hideUIHotkeyName = "H"
end
function mainJump.setHotkey(value)
    local key =
        mainFindKeyCode(
            value
        )
    if not key then
        return
    end
    mainJump.hotkeyName =
        key.Name
    mainJump.hotkeyBox.Text =
        key.Name
    mainJump.saveConfig()
    mainJump.capturing = nil
end
function mainJump.setHideUIHotkey(value)
    local key =
        mainFindKeyCode(
            value
        )
    if not key then
        return
    end
    mainJump.hideUIHotkeyName =
        key.Name
    mainJump.hideUIHotkeyBox.Text =
        key.Name
    mainJump.saveConfig()
    mainJump.capturing = nil
end
function mainJump.startCapture(kind)
    mainJump.capturing =
        kind
    if kind == "jump" then
        mainJump.hotkeyBox.Text =
            "PRESS KEY..."
    else
        mainJump.hideUIHotkeyBox.Text =
            "PRESS KEY..."
    end
end
function mainJump.destroySensors()
    if mainJump.sensorTouchConnection then
        pcall(function()
            mainJump.sensorTouchConnection:Disconnect()
        end)
        mainJump.sensorTouchConnection = nil
    end
    if mainJump.frontSensorTouchConnection then
        pcall(function()
            mainJump.frontSensorTouchConnection:Disconnect()
        end)
        mainJump.frontSensorTouchConnection = nil
    end
    if mainJump.sensorPart then
        pcall(function()
            mainJump.sensorPart:Destroy()
        end)
        mainJump.sensorPart = nil
    end
    if mainJump.frontSensorPart then
        pcall(function()
            mainJump.frontSensorPart:Destroy()
        end)
        mainJump.frontSensorPart = nil
    end
end
function mainJump.canJump()
    if not genv.DEADEYE_MAIN_RUNNING
        or not mainJump.enabled
        or not mainJump.humanoid
        or mainJump.humanoid.Health <= 0
    then
        return false
    end
    if mainJump.humanoid.FloorMaterial
        == Enum.Material.Air
    then
        return false
    end
    local state =
        mainJump.humanoid:GetState()
    return state
        ~= Enum.HumanoidStateType.Jumping
        and state
            ~= Enum.HumanoidStateType.Freefall
        and state
            ~= Enum.HumanoidStateType.FallingDown
end
function mainJump.jump(hit)
    if not mainJump.canJump() then
        return
    end
    mainJump.lastJump = tick()
    mainJump.humanoid.Jump = true
    pcall(function()
        mainJump.humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )
    end)
end
function mainJump.contact(hit)
    if not genv.DEADEYE_MAIN_RUNNING
        or not mainJump.enabled
        or not hit
    then
        return
    end
    if mainJump.character
        and hit:IsDescendantOf(
            mainJump.character
        )
    then
        return
    end
    task.wait(
        mainJump.jumpDelay
    )
    if not genv.DEADEYE_MAIN_RUNNING
        or not mainJump.enabled
    then
        return
    end
    mainJump.jump(hit)
end
function mainJump.createSensors(char)
    if not char
        or not char:IsA("Model")
    then
        return
    end

    mainJump.destroySensors()
    mainJump.character = char
    mainJump.humanoid =
        char:WaitForChild(
            "Humanoid"
        )
    mainJump.root =
        char:WaitForChild(
            "HumanoidRootPart"
        )
    local sensor =
        Instance.new("Part")
    sensor.Name =
        "FootJumpSensor"
    sensor.Size =
        Vector3.new(
            2.6,
            0.15,
            2.6
        )
    sensor.Transparency = 1
    sensor.Anchored = false
    sensor.CanCollide = false
    sensor.CanTouch = true
    sensor.CanQuery = false
    sensor.Massless = true
    sensor.CastShadow = false
    sensor.CFrame =
        mainJump.root.CFrame
        * CFrame.new(
            0,
            -3,
            0
        )
    sensor.Parent = char
    local weld =
        Instance.new(
            "WeldConstraint"
        )
    weld.Part0 =
        mainJump.root
    weld.Part1 =
        sensor
    weld.Parent =
        sensor
    mainJump.sensorPart =
        sensor
    mainJump.sensorTouchConnection =
        sensor.Touched:Connect(
            function(hit)
                mainJump.contact(hit)
            end        )
    local front =
        Instance.new("Part")
    front.Name =
        "FrontJumpSensor"
    front.Size =
        Vector3.new(
            2,
            3,
            1
        )
    front.Transparency = 1
    front.Anchored = false
    front.CanCollide = false
    front.CanTouch = true
    front.CanQuery = false
    front.Massless = true
    front.CastShadow = false
    front.CFrame =
        mainJump.root.CFrame
        * CFrame.new(
            0,
            -1,
            -0.8
        )
    front.Parent = char
    local frontWeld =
        Instance.new(
            "WeldConstraint"
        )
    frontWeld.Part0 =
        mainJump.root
    frontWeld.Part1 =
        front
    frontWeld.Parent =
        front
    mainJump.frontSensorPart =
        front
    mainJump.frontSensorTouchConnection =
        front.Touched:Connect(
            function(hit)
                mainJump.contact(hit)
            end
        )
end
genv.DEADEYE_MAIN_RUNNING = true
mainPage =
    Instance.new("ScrollingFrame")
mainPage.Name =
    "MainPage"
mainPage.Size =
    UDim2.new(
        1,
        -92,
        1,
        -56
    )
mainPage.Position =
    UDim2.new(
        0,
        82,
        0,
        48
    )
mainPage.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
mainPage.BorderSizePixel = 0
mainPage.ScrollBarThickness = 6
mainPage.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
mainPage.ScrollingDirection =
    Enum.ScrollingDirection.Y
mainPage.Visible = false
mainPage.Parent = Main
__UI.mainCorner =
    Instance.new("UICorner")
__UI.mainCorner.CornerRadius =
    UDim.new(
        0,
        9
    )
__UI.mainCorner.Parent =
    mainPage
local mainPadding =
    Instance.new("UIPadding")
mainPadding.PaddingTop =
    UDim.new(
        0,
        8
    )
mainPadding.PaddingBottom =
    UDim.new(
        0,
        8
    )
mainPadding.PaddingLeft =
    UDim.new(
        0,
        8
    )
mainPadding.PaddingRight =
    UDim.new(
        0,
        8
    )
mainPadding.Parent =
    mainPage
__UI.mainLayout =
    Instance.new("UIListLayout")
__UI.mainLayout.Padding =
    UDim.new(
        0,
        6
    )
__UI.mainLayout.SortOrder =
    Enum.SortOrder.LayoutOrder
__UI.mainLayout.Parent =
    mainPage
local function mainRow(labelText, order)
    local row =
        Instance.new("Frame")
    row.Size =
        UDim2.new(
            1,
            -4,
            0,
            40
        )
    row.BackgroundColor3 =
        Color3.fromRGB(
            40,
            40,
            40
        )
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = mainPage

    local rowStroke =
        Instance.new("UIStroke")
    rowStroke.Thickness =
        1
    rowStroke.Transparency =
        0.88
    rowStroke.Parent =
        row

    local rowCorner =
        Instance.new("UICorner")
    rowCorner.CornerRadius =
        UDim.new(
            0,
            7
        )
    rowCorner.Parent =
        row
    return row
end
__UI.autoRow =
    mainRow(
        "AUTOJUMP",
        1
    )
local autoLabel =
    Instance.new("TextLabel")
autoLabel.Size =
    UDim2.new(
        0.7,
        0,
        1,
        0
    )
autoLabel.Position =
    UDim2.new(
        0,
        10,
        0,
        0
    )
autoLabel.BackgroundTransparency = 1
autoLabel.Text = "AUTOJUMP"
autoLabel.TextSize = 11
autoLabel.Font = Enum.Font.GothamBold
autoLabel.TextColor3 =
    Color3.fromRGB(
        215,
        215,
        215
    )
autoLabel.TextXAlignment =
    Enum.TextXAlignment.Left
autoLabel.Parent = __UI.autoRow
mainJump.toggle =
    Instance.new("TextButton")
mainJump.toggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
mainJump.toggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
mainJump.toggle.BorderSizePixel = 0
mainJump.toggle.TextSize = 10
mainJump.toggle.Font =
    Enum.Font.GothamBold
mainJump.toggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.toggle.Parent =
    __UI.autoRow
__UI.toggleCorner =
    Instance.new("UICorner")
__UI.toggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.toggleCorner.Parent =
    mainJump.toggle
mainConnect(
    mainJump.toggle.MouseButton1Click:Connect(
        function()
            mainJump.setEnabled(
                not mainJump.enabled
            )
        end
    )
)
__UI.delayRow =
    mainRow(
        "DELAY",
        2
    )
__UI.delayLabel =
    autoLabel:Clone()
__UI.delayLabel.Text =
    "DELAY"
__UI.delayLabel.Parent =
    __UI.delayRow
mainJump.delayBox =
    Instance.new("TextBox")
mainJump.delayBox.Size =
    UDim2.new(
        1,
        -190,
        0,
        28
    )
mainJump.delayBox.Position =
    UDim2.new(
        0,
        105,
        0.5,
        -14
    )
mainJump.delayBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
mainJump.delayBox.BorderSizePixel = 0
mainJump.delayBox.ClearTextOnFocus = false
mainJump.delayBox.Text =
    tostring(
        mainJump.jumpDelay
    )
mainJump.delayBox.TextSize = 11
mainJump.delayBox.Font =
    Enum.Font.Gotham
mainJump.delayBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.delayBox.Parent =
    __UI.delayRow
__UI.delayCorner =
    Instance.new("UICorner")
__UI.delayCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.delayCorner.Parent =
    mainJump.delayBox
local delaySet =
    Instance.new("TextButton")
delaySet.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
delaySet.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
delaySet.BackgroundColor3 =
    Color3.fromRGB(
        52,
        52,
        52
    )
delaySet.BorderSizePixel = 0
delaySet.Text = "SET"
delaySet.TextSize = 9
delaySet.Font =
    Enum.Font.GothamBold
delaySet.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
delaySet.Parent =
    __UI.delayRow
__UI.delaySetCorner =
    Instance.new("UICorner")
__UI.delaySetCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.delaySetCorner.Parent =
    delaySet
mainConnect(
    delaySet.MouseButton1Click:Connect(
        function()
            mainJump.setDelay(
                mainJump.delayBox.Text
            )
        end
    )
)
mainConnect(
    mainJump.delayBox.FocusLost:Connect(
        function(enterPressed)
            if enterPressed then
                mainJump.setDelay(
                    mainJump.delayBox.Text
                )
            end
        end
    )
)
__UI.hotkeyRow =
    mainRow(
        "HOTKEY",
        3
    )
__UI.hotkeyLabel =
    autoLabel:Clone()
__UI.hotkeyLabel.Text =
    "HOTKEY"
__UI.hotkeyLabel.Parent =
    __UI.hotkeyRow
mainJump.hotkeyBox =
    Instance.new("TextButton")
mainJump.hotkeyBox.Size =
    UDim2.new(
        1,
        -120,
        0,
        28
    )
mainJump.hotkeyBox.Position =
    UDim2.new(
        0,
        105,
        0.5,
        -14
    )
mainJump.hotkeyBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
mainJump.hotkeyBox.BorderSizePixel = 0
mainJump.hotkeyBox.Text =
    mainJump.hotkeyName
mainJump.hotkeyBox.TextSize = 11
mainJump.hotkeyBox.Font =
    Enum.Font.Gotham
mainJump.hotkeyBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.hotkeyBox.Parent =
    __UI.hotkeyRow
__UI.hotkeyCorner =
    Instance.new("UICorner")
__UI.hotkeyCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.hotkeyCorner.Parent =
    mainJump.hotkeyBox
mainConnect(
    mainJump.hotkeyBox.MouseButton1Click:Connect(
        function()
            mainJump.startCapture(
                "jump"
            )
        end
    )
)
__UI.hideRow =
    mainRow(
        "HIDE UI",
        4
    )
__UI.hideLabel =
    autoLabel:Clone()
__UI.hideLabel.Text =
    "HIDE UI"
__UI.hideLabel.Parent =
    __UI.hideRow
mainJump.hideUIHotkeyBox =
    Instance.new("TextButton")
mainJump.hideUIHotkeyBox.Size =
    UDim2.new(
        1,
        -120,
        0,
        28
    )
mainJump.hideUIHotkeyBox.Position =
    UDim2.new(
        0,
        105,
        0.5,
        -14
    )
mainJump.hideUIHotkeyBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
mainJump.hideUIHotkeyBox.BorderSizePixel = 0
mainJump.hideUIHotkeyBox.Text =
    mainJump.hideUIHotkeyName
mainJump.hideUIHotkeyBox.TextSize = 11
mainJump.hideUIHotkeyBox.Font =
    Enum.Font.Gotham
mainJump.hideUIHotkeyBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.hideUIHotkeyBox.Parent =
    __UI.hideRow
__UI.hideCorner =
    Instance.new("UICorner")
__UI.hideCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.hideCorner.Parent =
    mainJump.hideUIHotkeyBox
mainConnect(
    mainJump.hideUIHotkeyBox.MouseButton1Click:Connect(
        function()
            mainJump.startCapture(
                "hide"
            )
        end
    )
)
mainConnect(
    UserInputService.InputBegan:Connect(
        function(input)
            if mainJump.capturing then
                local keyCode =
                    input.KeyCode
                if not keyCode
                    or keyCode
                        == Enum.KeyCode.Unknown
                then
                    return
                end
                if mainJump.capturing
                    == "jump"
                then
                    mainJump.setHotkey(
                        keyCode.Name
                    )
                else
                    mainJump.setHideUIHotkey(
                        keyCode.Name
                    )
                end
                return
            end

            if input.KeyCode
                == mainFindKeyCode(
                    mainJump.hotkeyName
                )
            then
                mainJump.setEnabled(
                    not mainJump.enabled
                )
            end
            if input.KeyCode
                == mainFindKeyCode(
                    mainJump.hideUIHotkeyName
                )
            then
                ScreenGui.Enabled =
                    not ScreenGui.Enabled
            end
        end
    )
)
mainConnect(
    UserInputService.JumpRequest:Connect(
        function()
            if mainJump.enabled
                or not genv.DEADEYE_MAIN_RUNNING
                or not mainJump.humanoid
                or not mainJump.humanoid.Parent
            then
                return
            end

            local humanoid = mainJump.humanoid

            if humanoid.Health <= 0
                or humanoid.FloorMaterial
                    == Enum.Material.Air
            then
                return
            end

            local state =
                humanoid:GetState()

            --// Native manual jump is allowed only while the
            --// humanoid is actually grounded. FloorMaterial alone
            --// can become non-Air slightly before physical contact.
            if state
                    ~= Enum.HumanoidStateType.Running
            then
                return
            end

            pcall(function()
                humanoid:SetStateEnabled(
                    Enum.HumanoidStateType.Jumping,
                    true
                )
                humanoid.Jump = true
                humanoid:ChangeState(
                    Enum.HumanoidStateType.Jumping
                )
            end)
        end
    )
)
mainConnect(
    LocalPlayer.CharacterAdded:Connect(
        function(char)
            task.wait(0.2)
            if genv.DEADEYE_MAIN_RUNNING then
                mainJump.createSensors(char)
            end
        end
    )
)
if LocalPlayer.Character
    and genv.DEADEYE_MAIN_RUNNING
then
    task.spawn(
        function()
            mainJump.createSensors(
                LocalPlayer.Character
            )
        end
    )
end
mainJump.update()
--// =========================================================
--// OTHERS PAGE
--// =========================================================
others.page =
    Instance.new("ScrollingFrame")
others.page.Name =
    "OthersPage"
others.page.Size =
    UDim2.new(
        1,
        -92,
        1,
        -56
    )
others.page.Position =
    UDim2.new(
        0,
        82,
        0,
        48
    )
others.page.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
others.page.BorderSizePixel =
    0
others.page.ScrollBarThickness =
    6
others.page.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
others.page.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
others.page.ScrollingDirection =
    Enum.ScrollingDirection.Y
others.page.Visible =
    false
others.page.Parent =
    Main
others.pageCorner =
    Instance.new("UICorner")
others.pageCorner.CornerRadius =
    UDim.new(
        0,
        9
    )
others.pageCorner.Parent =
    others.page
others.padding =
    Instance.new("UIPadding")
others.padding.PaddingTop =
    UDim.new(
        0,
        8
    )
others.padding.PaddingBottom =
    UDim.new(
        0,
        8
    )
others.padding.PaddingLeft =
    UDim.new(
        0,
        8
    )
others.padding.PaddingRight =
    UDim.new(
        0,
        8
    )
others.padding.Parent =
    others.page
others.layout =
    Instance.new("UIListLayout")
others.layout.Padding =
    UDim.new(
        0,
        6
    )
others.layout.SortOrder =
    Enum.SortOrder.LayoutOrder
others.layout.Parent =
    others.page
function others.header(
    textValue,
    orderValue
)
    local header =
        Instance.new("TextLabel")
    header.Size =
        UDim2.new(
            1,
            -4,
            0,
            24
        )
    header.BackgroundTransparency =
        1
    header.Text =
        textValue
    header.TextSize =
        10
    header.Font =
        Enum.Font.GothamBold
    header.TextColor3 =
        Color3.fromRGB(
            150,
            150,
            150
        )
    header.TextXAlignment =
        Enum.TextXAlignment.Left
    header.LayoutOrder =
        orderValue
    header.Parent =
        others.page
end
function others.row(
    slot,
    orderValue
)
    local row =
        Instance.new("Frame")
    row.Name =
        "Slot_" ..
        slot.property
    row.Size =
        UDim2.new(
            1,
            -4,
            0,
            40
        )
    row.BackgroundColor3 =
        Color3.fromRGB(
            40,
            40,
            40
        )
    row.BorderSizePixel =
        0
    row.LayoutOrder =
        orderValue
    row.Parent =
        others.page
    local corner =
        Instance.new("UICorner")
    corner.CornerRadius =
        UDim.new(
            0,
            6
        )
    corner.Parent =
        row
    local label =
        Instance.new("TextLabel")
    label.Size =
        UDim2.new(
            0,
            105,
            1,
            0
        )
    label.Position =
        UDim2.new(
            0,
            10,
            0,
            0
        )
    label.BackgroundTransparency =
        1
    label.Text =
        slot.label
    label.TextSize =
        11
    label.Font =
        Enum.Font.GothamBold
    label.TextColor3 =
        Color3.fromRGB(
            215,
            215,
            215
        )
    label.TextXAlignment =
        Enum.TextXAlignment.Left
    label.Parent =
        row
    local box =
        Instance.new("TextBox")
    box.Size =
        UDim2.new(
            1,
            -190,
            0,
            28
        )
    box.Position =
        UDim2.new(
            0,
            105,
            0.5,
            -14
        )
    box.BackgroundColor3 =
        Color3.fromRGB(
            32,
            32,
            32
        )
    box.BorderSizePixel =
        0
    box.ClearTextOnFocus =
        false
    box.PlaceholderText =
        slot.multi
        and "ID or ID,ID"
        or "Empty"
    box.TextSize =
        11
    box.Font =
        Enum.Font.Gotham
    box.TextColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )
    box.PlaceholderColor3 =
        Color3.fromRGB(
            105,
            105,
            105
        )
    box.TextXAlignment =
        Enum.TextXAlignment.Left
    box.Parent =
        row
    local boxCorner =
        Instance.new("UICorner")
    boxCorner.CornerRadius =
        UDim.new(
            0,
            5
        )
    boxCorner.Parent =
        box
    local apply =
        Instance.new("TextButton")
    apply.Size =
        UDim2.new(
            0,
            65,
            0,
            28
        )
    apply.Position =
        UDim2.new(
            1,
            -75,
            0.5,
            -14
        )
    apply.BackgroundColor3 =
        Color3.fromRGB(
            52,
            52,
            52
        )
    apply.BorderSizePixel =
        0
    apply.Text =
        "APPLY"
    apply.TextSize =
        9
    apply.Font =
        Enum.Font.GothamBold
    apply.TextColor3 =
        Color3.fromRGB(
            255,
            255,

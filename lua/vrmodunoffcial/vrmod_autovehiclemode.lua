if SERVER then return end
hook.Add(
    "Think",
    "CheckPlayerInVehicle",
    function()
        local ply = LocalPlayer() -- 自分自身のプレイヤーオブジェクトを取得
        -- プレイヤーが車両に乗っているか確認
        if ply:InVehicle() then
            local vehicle = ply:GetVehicle() -- プレイヤーが乗っている車両を取得

            -- 車両がLFS車両かどうか確認
            if vehicle.LVS then
                RunConsoleCommand("vrmod_vehicle_reticlemode", "1") -- コンソールコマンドを実行
            end

            -- 車両がSimfphys車両かどうか確認
            if vehicle.Simfphys then
                RunConsoleCommand("vrmod_vehicle_reticlemode", "0") -- コンソールコマンドを実行
            end
        end
    end
)
# mo_parkingMeter
Use the parking meters on the map of GTA for FiveM [lua]

[[HOW IT WORKS]]
- Players should park their vehicle near a parking meter and then press "E" or "X" to pay.
- When a police man walks by and sees that the parking meter is at 0 he can write a parking ticket.

(When the script or the server gets restarted all parking meters will be resetted.)

If you registered in your ``es_extended`` an extra Account for "cash" then change the ``config.lua/Config.useCashAccount`` to true and perhaps also change the ``config.lua/Config.accountType``.

[[VARIABLES]]
- Config.trigger_key1 : Control key to extend the parking meter for one hour.
- Config.trigger_key10 : Control key to extend the parking meter for ten hours.
- Config.price : Price which the parking meter will cost per hour.
- Config.HourTimer : Interval in minutes in which "one hour" of the parking meter time will be removed.

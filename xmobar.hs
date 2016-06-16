-- xmobar config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config

-- This is setup for dual 1920x1080 monitors, with the right monitor as primary
Config {
    font = "xft:Fixed-10",
    bgColor = "#000000",
    fgColor = "#ffffff",
    position = TopW C 100,
--    position = TopW L 100,
--    position = Static { xpos = 0, ypos = 0, width = 2560, height = 16 },
    -- position = Static { xpos = 0, ypos = 0, width = 1920, height = 16 },
    lowerOnStart = True,
    commands = [
        Run MultiCpu ["-t","Cpu: <total0> <total1> <total2> <total3>","-L","30","-H","60","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 10,
        Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Swap ["-t","Swap: <usedratio>%","-H","1024","-L","512","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Date "%a %b %e W%V %k:%M:%S" "date" 10,
        Run Com "python" ["/home/mpemer/src/xmonad-pulsevolume/show-volume.py"] "vol" 1,
        Run Com "python" ["/home/mpemer/src/xmonad-pulsevolume/mic-show-volume.py"] "mic" 1,
        Run Com "xbacklight" [] "bkl" 1,
--        Run Com "nmcli" ["r","wwan"] "wwan" 1,
--        Run Com "nmcli" ["r","wifi"] "wifi" 1,
        Run Com "/home/mpemer/bin/bat_status.sh" ["BAT0"] "bat0" 1,
        Run Com "/home/mpemer/bin/bat_status.sh" ["BAT1"] "bat1" 1,
        Run StdinReader]
,
    sepChar = "%",
    alignSep = "}{",
    template = "%StdinReader% }{%multicpu%  %memory%  <fc=#FFFFCC>%mic%</fc>  %vol%  %bkl%  Bat: %bat0% %bat1%  <fc=#FFFFCC>%date%</fc>"
}

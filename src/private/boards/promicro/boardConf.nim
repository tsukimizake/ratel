include "../helpers/avrBoardConf.nim"

proc build*(file: string) =
  exec "nim c -d:danger --os:any " & file

proc upload*(device: string, file: string) =
  exec "avr-objcopy -O ihex " & file & " " & file & ".hex"
  exec "avrdude -c avr109 -p m32u4 -D -U flash:w:" & file & ".hex:i -v -v -v -v -P " & device
  exec "rm " & file & ".hex"
  exec "rm " & file

proc size*(file: string) =
  exec "avr-size -C --mcu=atmega32u4 " & file

proc sizeDetails*(file: string) =
  size(file)
  echo ".data section:"
  exec "avr-nm -S --size-sort " & file & " | grep \" [Dd] \" || echo \"empty\""
  echo ""
  echo ".bss section:"
  exec "avr-nm -S --size-sort " & file & " | grep \" [Bb] \" || echo \"empty\""
  echo ""
  echo ".text section:"
  exec "avr-nm -S --size-sort " & file & " | grep \" [Tt] \" || echo \"empty\""

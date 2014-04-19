@echo off
..\DelphiProtocolBuffer\dpbp -fPnEf ql2.proto
..\DelphiProtocolBuffer\dpbp -fPnEf -i. ql2_extensions.proto
pause
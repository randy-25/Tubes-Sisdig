# tubes-sisdig

Program ini adalah program kalkulator FPB dan KPK, yang telah dilengkapi dengan input dan output yang dapat muncul pada serial monitor menggunakan UART. Perhitungan FPB dan KPK dilakukan melalui FPGA, dan didesain menggunakan VHDL. Masih banyak terdapat kekurangan dalam desain ini, seperti cukup lamanya perhitungan untuk FPB dan KPK pada input yang cukup besar, serta output yang masih menunjukkan posisi yang salah dalam mode 2 hasil KPK <br/> <br/>

Top level entity dari program ini adalah uart.vhd <br/><br/>
Cara untuk menjalankannya adalah dengan menginput 5 buah angka, dengan angka pertama berupa mode, angka kedua sampai keempat adalah 4 buah input dari FPB dan KPK yang ingin dicari nilainya. <br/><br/>
Karena keterbatasan dari desain yang dibuat, input yang diberikan harus memenuhi spesifikasi sebagai berikut : <br/>
mode : [0, 1, 2] --> mode 0 adalah FPB, mode 1 adalah KPK, dan mode 2 adalah FPB dan KPK <br/>
4input sisanya : 3 digit angka, jika ingin menginput angka kecil, gunakan 0 di depannya, e.g. 001 002 003 004 <br/><br/>
Gunakan spasi sebagai pemisah antar input!!!

# liquid_honey_hyperspectral_image_analysis
**Ini adalah <em>repository</em> untuk mendokumentasikan hasil penelitian skripsi S1 saya pada prodi Fisika UI**

Dalam rangka penyelesaian studi S1 saya pada prodi Fisika UI, saya mengambil tema penelitian yang sedang <em>hype</em> pada saat itu, yakni pengolahan citra dengan metode <em>Machine Learning</em>. Secara pribadi, penelitian ini sangat berkesan bagi saya. Selain karena teman-teman satu grup yang kompak, saat-saat itu adalah waktu pertama kali saya berkenalan dengan bidang keilmuan <em>Data Science</em> dan <em>Machine Learning</em>, hingga saya memutuskan untuk menekuni bidang tersebut sampai saat ini.
  
## Tujuan Penelitian
Penelitian ini dilakukan dengan tujuan utama sebagai berikut:
1. Membandingkan akurasi yang dihasilkan oleh metode pengukuran spektrum transmitansi dan reflektansi dalam prediksi parameter-parameter kualitas madu berbasis <em>hyperspectral imaging</em>.
2. Mengetahui pengaruh dari komponen-komponen kimiawi pada madu terhadap performa dari model prediksi parameter kualitas madu yang dihasilkan.

## Desain Eksperimen
Eksperimen dilakukan setelah seluruh sistem yang terdiri atas perangkat lunak dan keras dapat bekerja dengan baik. Eksperimen diawali dengan preparasi sampel yang berfungsi untuk menghilangkan gelembung-gelembung kecil yang dapat menghasilkan noise pada citra yang dihasilkan. Sebelum akuisisi citra dilakukan, nilai referensi TSS, pH, dan EC diukur dengan instrumen konvensional sebagai target untuk kalibrasi model. Lalu, pengolahan citra dilakukan untuk mendapatkan model regresi dari parameter-parameter target yang telah ditentukan. Terakhir, performa model regresi untuk pengukuran spektrum transmitansi dan reflektansi dibandingkan dengan mengacu pada nilai R2 dan RMSE yang divalidasi dengan metode <em>k-fold Cross-Validation</em>.

Gambar di bawah adalah bagan desain eksperimen secara keseluruhan, <br>
<p align="center"><img src="https://github.com/dioz95/liquid_honey_hyperspectral_image_analysis/blob/main/desain_eksperimen.png" width="500"></p>

## Penjelasan Code
Eksperimen ini sebenarnya dilakukan secara <em>end-to-end</em> mulai dari pengambilan sampel sampai dengan validasi hasil. Akan tetapi, <em>repo</em> kali ini hanya berfokus pada sisi perangkat lunaknya saja. File `avg_R_V_Madu_1-30.mat` dan `avg_T_V_Madu_1-30.mat` secara berurutan merupakan data kumpulan spektrum reflektansi dan reflektansi yang telah diekstrak dari citra-citra hiperspektral. Data dari kedua file ini kemudian akan diberikan sebagai input pada file MATLAB `Madu_Ref_PLS_GPR_CrossVal.m` dan `Madu_Trans_PLS_GPR_CrossVal.m` untuk diolah dengan menggunakan metode reduksi dimensi PLS dan <em>Gaussian Processes Regression</em> dengan <em>k-fold Cross-Validation</em> sebagai metode validasi.

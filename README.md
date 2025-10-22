# Oracle Retail Inventory Database

Bu repository, çok mağazalı bir perakende envanter sistemini yönetmek için tasarlanmış kapsamlı bir Oracle veritabanı şemasıdır.

Sistem, merkezi bir depo ile birden fazla mağaza arasındaki stok hareketlerini yönetmek için PL/SQL prosedürlerini, fonksiyonlarını ve trigger'larını kullanır. Veri bütünlüğünü sağlar ve transfer süreçlerini otomatikleştirir.

## Temel Özellikler

* **Normalleştirilmiş Şema:** Ürünler, markalar, kategoriler, mağazalar, tedarikçiler ve ana depo için tasarlanmış normalleştirilmiş tablolar.
* **Stok Yönetimi:** `AnaDepoHareketEkle` ve `MagazaHareketEkle` prosedürleri aracılığıyla stok giriş/çıkış operasyonları.
* **Otomatik Transferler:** `AnaDepoMagazaTransferEkle` prosedürü ile depo-mağaza arası transferlerin yönetimi.
* **Anlık Güncellemeler:** `TRG_ANAURUNHAREKET` ve `TRG_MAGAZAHAREKET` trigger'ları ile envanterin anlık olarak güncellenmesi.
* **Veri Bütünlüğü:** `StokYeterliMi` ve `MagazaStokYeterliMi` fonksiyonları ile negatif stok kontrolleri.
* **Raporlama:** `MagazaOlmayanUrunleriListele` gibi envanter raporlama prosedürleri.

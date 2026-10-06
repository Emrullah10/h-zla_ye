# Hızla birim ekonomi modeli. Tüm girdiler TL, KDV hariç. [K]=kaynaklı (araştırma notu), [T]=tahmin
FUEL_TL_L = 80.0          # [K] İstanbul benzin ~80 TL/L (Ekim 2026, tek kaynak)
L_PER_100KM = 2.2         # [K] 110-125cc 1,8-2,5 L/100km
FUEL_KM = FUEL_TL_L*L_PER_100KM/100
KM_PER_PKG = 6.0          # [T] alım+teslim+konumlanma
OTHER_COST_MONTH = 3500   # [T] bakım 1000 + amortisman 1500 + telefon/veri 500 + ekipman 500
HOURS_MONTH = 208         # [T] 8 sa x 26 gün
MIN_NET = 28075.50        # [K] 2026 net asgari ücret
MIN_NET_H = MIN_NET/195   # yasal 195 sa/ay
VAR_COST = 4.0            # [T] Hızla değişken maliyet/paket
print(f"yakıt/km={FUEL_KM:.2f} TL, paket başı yakıt={FUEL_KM*KM_PER_PKG:.1f} TL, asgari net saatlik={MIN_NET_H:.0f} TL")

def courier_net_h(pay, pph):
    gross = pay*pph
    fuel = FUEL_KM*KM_PER_PKG*pph
    other = OTHER_COST_MONTH/HOURS_MONTH
    return gross, gross-fuel-other

print("\n# Kurye: paket ücreti x verim -> brüt / net(yakıt+bakım sonrası, Bağ-Kur ve vergi ÖNCESİ) saatlik")
for pay in (60,70,80,90):
    row=[]
    for pph in (2.0,2.5,3.0):
        g,n=courier_net_h(pay,pph); row.append(f"{g:.0f}/{n:.0f}")
    print(pay, row)

# Garanti: slot saatlik asgari kazanç (brüt paket geliri altına düşerse Hızla tamamlar)
print("\n# Saatlik garanti maliyeti (paket ücreti 75 TL): garanti 170 TL/sa")
G=170; PAY=75
for pph in (1.5,2.0,2.27,2.5):
    topup=max(0,G-PAY*pph); print(f"verim {pph}: tamamlama {topup:.0f} TL/sa = {topup/pph if pph else 0:.1f} TL/paket")

print("\n# Hızla katkısı (fiyat - kurye ücreti - değişken)")
for price in (95,105,115):
    print(price, [f"pay{p}:{price-p-VAR_COST:.0f}" for p in (70,75,80)])

print("\n# İşletme: platform kuryesi farkı %20 (dağıtım) -> başabaş sepet = fiyat/0,20")
for price in (75,95,105,115): print(price, f"{price/0.20:.0f} TL")
print("Tasarruf tablosu (vale %32 vs %12 + Hızla fiyatı):")
for basket in (400,500,600,700):
    print(basket, [f"{p}:{(basket*0.32-(basket*0.12+p))/(basket*0.32)*100:+.0f}%" for p in (95,105,115)])

# Pilot aylık P&L
print("\n# Pilot (aylık, 30 gün)")
for per_day in (350,500,750):
    pkgs=per_day*30; price=105; pay=75
    rev=pkgs*price; courier=pkgs*pay; var=pkgs*VAR_COST
    guarantee=pkgs*2.5   # [T] ortalama 2,5 TL/paket garanti tamamlaması
    fixed=  2*62000 + 52000 + 25*1500 + 12000 + 15000 + 30000 + 25000  # ops 2, destek 1, kaza sig., ekipman, altyapı, ofis, hukuk/mali
    contrib=rev-courier-var-guarantee
    print(f"{per_day}/gün: gelir {rev/1e3:.0f}k, kurye {courier/1e3:.0f}k, katkı {contrib/1e3:.0f}k, sabit {fixed/1e3:.0f}k, sonuç {(contrib-fixed)/1e3:+.0f}k")
fixed=2*62000+52000+25*1500+12000+15000+30000+25000
unit=105-75-VAR_COST-2.5
print(f"başabaş paket/gün = {fixed/unit/30:.0f}")
# İşletme sermayesi
for days in (14,45):
    print(f"kurye haftalık öde, işletme {days} gün sonra öder: finansman ~{500*75*days/1e3:.0f}k TL (500 paket/gün)")

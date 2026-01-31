# PowerShell script to download product images
# Run this script to download all product images to assets/images folders

$images = @(
    # Oils
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-coconut-oil.jpg"; path="assets/images/oils/coconut_oil.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-sesame-nallennai-oil.jpg"; path="assets/images/oils/sesame_oil.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-groundnut-oil.jpg"; path="assets/images/oils/groundnut_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&q=80"; path="assets/images/oils/mustard_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=400&q=80"; path="assets/images/oils/castor_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1566394072647-abec60f3f48b?w=400&q=80"; path="assets/images/oils/almond_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1625869016774-83c1b4e10e25?w=400&q=80"; path="assets/images/oils/sunflower_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&q=80"; path="assets/images/oils/olive_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=400&q=80"; path="assets/images/oils/neem_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1585515320310-d745e47d1ce0?w=400&q=80"; path="assets/images/oils/flaxseed_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&q=80"; path="assets/images/oils/rice_bran_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=400&q=80"; path="assets/images/oils/palm_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1599003302607-421ecf611769?w=400&q=80"; path="assets/images/oils/walnut_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=400&q=80"; path="assets/images/oils/avocado_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1570493821432-1cc49bba96f0?w=400&q=80"; path="assets/images/oils/pumpkin_seed_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&q=80"; path="assets/images/oils/safflower_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1608058403116-271e03a0fb78?w=400&q=80"; path="assets/images/oils/peanut_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=400&q=80"; path="assets/images/oils/soybean_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400&q=80"; path="assets/images/oils/corn_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1537640538966-79f369143f8f?w=400&q=80"; path="assets/images/oils/grape_seed_oil.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-sesame-nallennai-oil.jpg"; path="assets/images/oils/sesame_oil_small.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-coconut-oil.jpg"; path="assets/images/oils/coconut_oil_small.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-groundnut-oil.jpg"; path="assets/images/oils/groundnut_oil_small.jpg"},
    @{url="https://images.unsplash.com/photo-1594486047460-a89c7e93ee08?w=400&q=80"; path="assets/images/oils/til_oil.jpg"},
    @{url="https://images.unsplash.com/photo-1522338242992-e1a54906a8da?w=400&q=80"; path="assets/images/oils/hair_oil.jpg"},

    # Flours
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-wheat-flour.jpg"; path="assets/images/flours/wheat_flour.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-rice-flour.jpg"; path="assets/images/flours/rice_flour.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-foxtail-millet-flour.jpg"; path="assets/images/flours/foxtail_millet_flour.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-greengram-flour.jpg"; path="assets/images/flours/greengram_flour.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-corn-flour.jpg"; path="assets/images/flours/corn_flour.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-peanut-flour.jpg"; path="assets/images/flours/peanut_flour.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/patanjali-atta.jpg"; path="assets/images/flours/atta_flour.jpg"},
    @{url="https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&q=80"; path="assets/images/flours/ragi_flour.jpg"},
    @{url="https://images.unsplash.com/photo-1596797038530-2c107229654b?w=400&q=80"; path="assets/images/flours/bajra_flour.jpg"},
    @{url="https://images.unsplash.com/photo-1612838320302-4b3b3b6b1b1e?w=400&q=80"; path="assets/images/flours/jowar_flour.jpg"},
    @{url="https://images.unsplash.com/photo-1574663876115-5cb5b97f36b4?w=400&q=80"; path="assets/images/flours/barley_flour.jpg"},
    @{url="https://images.unsplash.com/photo-1599003300222-f45df9e2e2b0?w=400&q=80"; path="assets/images/flours/gram_flour.jpg"},
    @{url="https://images.unsplash.com/photo-1628690881924-490a17c7f494?w=400&q=80"; path="assets/images/flours/maida_flour.jpg"},
    @{url="https://images.unsplash.com/photo-1574663876115-5cb5b97f36b4?w=400&q=80"; path="assets/images/flours/oats_flour.jpg"},
    @{url="https://images.unsplash.com/photo-1553787762-3d2b5d2f4023?w=400&q=80"; path="assets/images/flours/amaranth_flour.jpg"},
    @{url="https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&q=80"; path="assets/images/flours/quinoa_flour.jpg"},
    @{url="https://images.unsplash.com/photo-1628690881924-490a17c7f494?w=400&q=80"; path="assets/images/flours/buckwheat_flour.jpg"},
    @{url="https://images.unsplash.com/photo-1612838320302-4b3b3b6b1b1e?w=400&q=80"; path="assets/images/flours/soya_flour.jpg"},
    @{url="https://images.unsplash.com/photo-1596797038530-2c107229654b?w=400&q=80"; path="assets/images/flours/little_millet_flour.jpg"},
    @{url="https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&q=80"; path="assets/images/flours/kodo_millet_flour.jpg"},
    @{url="https://images.unsplash.com/photo-1628690881924-490a17c7f494?w=400&q=80"; path="assets/images/flours/barnyard_millet_flour.jpg"},
    @{url="https://images.unsplash.com/photo-1553787762-3d2b5d2f4023?w=400&q=80"; path="assets/images/flours/multi_grain_flour.jpg"},

    # Beauty Products
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/marutham-herbal-aloe-vera-gel.jpg"; path="assets/images/beauty/aloe_vera_gel.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/haiocare-arappu-Albizia-amara-powder.jpg"; path="assets/images/beauty/arappu_powder.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/kasturi-manjal.jpg"; path="assets/images/beauty/curcuma_aromatica.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/marutham-multani-mitti-powder.jpg"; path="assets/images/beauty/fullers_earth.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/magil-herbal-facebeauty-powder.jpg"; path="assets/images/beauty/face_beauty_powder.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/marutham-herbal-bathing-powder.jpg"; path="assets/images/beauty/bath_powder.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/kumkumadi-thailam.jpg"; path="assets/images/beauty/kumkumadi_thailam.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/patanjali-saundarya-aloe-vera-face-wash-gel.jpg"; path="assets/images/beauty/face_wash_aloe_vera.jpg"},
    @{url="https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=400&q=80"; path="assets/images/beauty/neem_face_pack.jpg"},
    @{url="https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=400&q=80"; path="assets/images/beauty/sandalwood_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1587556930724-83844dabb752?w=400&q=80"; path="assets/images/beauty/rose_water.jpg"},
    @{url="https://images.unsplash.com/photo-1562620669-59f4e22e9e98?w=400&q=80"; path="assets/images/beauty/hibiscus_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=400&q=80"; path="assets/images/beauty/shikakai_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400&q=80"; path="assets/images/beauty/amla_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=400&q=80"; path="assets/images/beauty/reetha_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=400&q=80"; path="assets/images/beauty/henna_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1614313913007-2b4ae8ce32d6?w=400&q=80"; path="assets/images/beauty/fenugreek_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1582979512210-99b6a53386f9?w=400&q=80"; path="assets/images/beauty/orange_peel_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1590502593747-42a996133562?w=400&q=80"; path="assets/images/beauty/lemon_peel_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1604977042946-1eecc30f269e?w=400&q=80"; path="assets/images/beauty/cucumber_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1546470427-227a13f3e820?w=400&q=80"; path="assets/images/beauty/tomato_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1517282009859-f000ec3b26fe?w=400&q=80"; path="assets/images/beauty/papaya_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1590671619502-3d4c6e4c5e8b?w=400&q=80"; path="assets/images/beauty/beetroot_powder.jpg"},

    # Health Products
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/vibhooothi-thiruneeru.jpg"; path="assets/images/health/vibhoothi.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/magil-herbal-nalangu-powder.jpg"; path="assets/images/health/nalangu_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1615485500834-bc10199bc727?w=400&q=80"; path="assets/images/health/turmeric_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=400&q=80"; path="assets/images/health/ginger_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=400&q=80"; path="assets/images/health/ashwagandha_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1600618528240-fb9fc964b853?w=400&q=80"; path="assets/images/health/moringa_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1505576399279-565b52d4ac71?w=400&q=80"; path="assets/images/health/spirulina_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1600618528240-fb9fc964b853?w=400&q=80"; path="assets/images/health/wheatgrass_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=400&q=80"; path="assets/images/health/giloy_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1618556662906-fa2d89550168?w=400&q=80"; path="assets/images/health/tulsi_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400&q=80"; path="assets/images/health/triphala_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=400&q=80"; path="assets/images/health/neem_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1600618528240-fb9fc964b853?w=400&q=80"; path="assets/images/health/brahmi_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=400&q=80"; path="assets/images/health/shatavari_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400&q=80"; path="assets/images/health/guggul_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=400&q=80"; path="assets/images/health/arjuna_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1600618528240-fb9fc964b853?w=400&q=80"; path="assets/images/health/punarnava_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=400&q=80"; path="assets/images/health/manjistha_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1600618528240-fb9fc964b853?w=400&q=80"; path="assets/images/health/bhringraj_powder.jpg"},
    @{url="https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400&q=80"; path="assets/images/health/haritaki_powder.jpg"},

    # Snacks
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-navathaaniya-dosai-mix.jpg"; path="assets/images/snacks/navathaaniya_dosai_mix.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/sibre-rich-minor-millets-bajji-mix.jpg"; path="assets/images/snacks/millet_bajji_mix.jpg"},
    @{url="https://gonaturo.in/wp-content/uploads/2020/10/ulutham-kanji-readymix-urad-mush-mix.jpg"; path="assets/images/snacks/urad_mush_mix.jpg"},
    @{url="https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&q=80"; path="assets/images/snacks/ragi_malt.jpg"},
    @{url="https://images.unsplash.com/photo-1628690881924-490a17c7f494?w=400&q=80"; path="assets/images/snacks/health_mix.jpg"},
    @{url="https://images.unsplash.com/photo-1553787762-3d2b5d2f4023?w=400&q=80"; path="assets/images/snacks/sathu_maavu.jpg"},
    @{url="https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&q=80"; path="assets/images/snacks/puttu_podi.jpg"},
    @{url="https://images.unsplash.com/photo-1630383249896-424e482df921?w=400&q=80"; path="assets/images/snacks/idli_dosa_batter.jpg"},
    @{url="https://images.unsplash.com/photo-1599003300222-f45df9e2e2b0?w=400&q=80"; path="assets/images/snacks/adai_mix.jpg"},
    @{url="https://images.unsplash.com/photo-1628690881924-490a17c7f494?w=400&q=80"; path="assets/images/snacks/rava_upma_mix.jpg"},
    @{url="https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&q=80"; path="assets/images/snacks/pongal_mix.jpg"},
    @{url="https://images.unsplash.com/photo-1589301760014-6e63e34ce6c6?w=400&q=80"; path="assets/images/snacks/payasam_mix.jpg"},
    @{url="https://images.unsplash.com/photo-1603569283847-aa295f0d016a?w=400&q=80"; path="assets/images/snacks/halwa_mix.jpg"},
    @{url="https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400&q=80"; path="assets/images/snacks/murukku_mix.jpg"},
    @{url="https://images.unsplash.com/photo-1628690881924-490a17c7f494?w=400&q=80"; path="assets/images/snacks/seedai_mix.jpg"},
    @{url="https://images.unsplash.com/photo-1603569283847-aa295f0d016a?w=400&q=80"; path="assets/images/snacks/laddu_mix.jpg"},
    @{url="https://images.unsplash.com/photo-1626074353765-517a65992e53?w=400&q=80"; path="assets/images/snacks/appalam.jpg"},
    @{url="https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400&q=80"; path="assets/images/snacks/vadam.jpg"},
    @{url="https://images.unsplash.com/photo-1628690881924-490a17c7f494?w=400&q=80"; path="assets/images/snacks/vadagam.jpg"},
    @{url="https://images.unsplash.com/photo-1615485500834-bc10199bc727?w=400&q=80"; path="assets/images/snacks/pickle_powder.jpg"}
)

$totalImages = $images.Count
$currentImage = 0

Write-Host "Downloading $totalImages product images..." -ForegroundColor Green
Write-Host ""

foreach ($img in $images) {
    $currentImage++
    $percentage = [math]::Round(($currentImage / $totalImages) * 100, 1)
    Write-Host "[$currentImage/$totalImages] ($percentage%) Downloading: $($img.path)" -ForegroundColor Cyan
    
    try {
        Invoke-WebRequest -Uri $img.url -OutFile $img.path -UseBasicParsing
        Write-Host "  [OK] Success" -ForegroundColor Green
    } catch {
        Write-Host "  [FAIL] Failed: $_" -ForegroundColor Red
    }
    
    Start-Sleep -Milliseconds 500
}

Write-Host ""
Write-Host "Download complete! All images saved to assets/images folders." -ForegroundColor Green

'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "5c0a3128d28dea63de1ad1a78b4c1b9f",
".git/config": "eb3f6b4236de3b692ad03ba24f46c2c8",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "4cf2d64e44205fe628ddd534e1151b58",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "3eeab1b042cb4a70350a74b6f931db9d",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "c861f6f717821dfd8fe1b100aa3bed32",
".git/logs/refs/heads/master": "c861f6f717821dfd8fe1b100aa3bed32",
".git/logs/refs/remotes/origin/gh-pages": "889779fa05ee0630be901c53c0fb4289",
".git/objects/00/9f65659f5d3f8a786686afbd516cfc6daaca08": "78d9b492b6f0584bf83faef45156f490",
".git/objects/02/b88ec956267a35f3029553f84f0063353dab7c": "5840100dcb48e5adb90d4d01830753c7",
".git/objects/08/39e55e995f269c67e12c8013ab0b8f8d882007": "11bc33d220c76db457c4c5fa492a8eb0",
".git/objects/08/58b113e67cb0c2cdaf67c905697b1a3cc8b4ff": "0dd1cfd08a6cd59b066e276310cd69ca",
".git/objects/09/5ced00c8de7f170907af894160d542a012bb9b": "626dbd475427ec4551d48ebe54c2ca6b",
".git/objects/0b/18d35a1dde9dd2cc68b861a4c220009c0dc56b": "624791d66bc4ade23be85368e9b15a03",
".git/objects/0f/4993ef35ef936173ee1b9fef1f0e4931d16b64": "d68b168a47e23401bc154cb48c9d9359",
".git/objects/11/c128711de399b6d7bbbf37f702e7f95a46469d": "d4e74df48734c7c3a55708e529793f03",
".git/objects/18/371fa06d7e2621144ae82f5dd0290a6edd13d1": "f33dd4473afa103a576e3e48598695d7",
".git/objects/1d/468b85698a60041b450286f31b3264b3bbd6f7": "5c8c497111befde32ac151f14cf92f85",
".git/objects/20/59e3660523d8c4c370abd5bfdc2867bdfa3fe9": "aaa0dc78cd7ab9ca3b5771d7d67c8270",
".git/objects/2a/6d16d4a925880fd4d4de0531853a3d65aa41e7": "504ffbfe032a2437d625196e1ff5407b",
".git/objects/34/6e27e99aa67c6d006eaa282d7601c7a970742a": "9019d2bd527757b0a626a702f99b4337",
".git/objects/35/5d7b54c9162ae917b036bc0d03b49f1065630b": "bd5bb730ca6c81deb12b6d0eed822d9b",
".git/objects/35/96d08a5b8c249a9ff1eb36682aee2a23e61bac": "e931dda039902c600d4ba7d954ff090f",
".git/objects/36/0f89d867aa0ba351b942990ef291de7d8fdb20": "d4accd82c6191a084a73df0ed57dee73",
".git/objects/39/d10198f5cc8d0d70a721200b8b10d17a3e572d": "93bd718967135c11e430bf0730b21b34",
".git/objects/3a/bf18c41c58c933308c244a875bf383856e103e": "30790d31a35e3622fd7b3849c9bf1894",
".git/objects/3b/d119def59e031aee57b207688b1acf5496be25": "2d1477252d16c5fb1a39bb032f3a4bde",
".git/objects/3e/287e2f74b3344964bf920f34260eee8ed857ee": "09092c2ea75e7e41269098474b067fc5",
".git/objects/40/1184f2840fcfb39ffde5f2f82fe5957c37d6fa": "1ea653b99fd29cd15fcc068857a1dbb2",
".git/objects/46/e2355c933a1d4c02fcf89b4e065de688673ffd": "63ef8244bfe98061628a13c23606b69d",
".git/objects/57/7946daf6467a3f0a883583abfb8f1e57c86b54": "846aff8094feabe0db132052fd10f62a",
".git/objects/5f/bf1f5ee49ba64ffa8e24e19c0231e22add1631": "f19d414bb2afb15ab9eb762fd11311d6",
".git/objects/69/2108d58462adcb9089d65e232192c46508ddcf": "113a185e554a65199ca4e44c2837693a",
".git/objects/72/3d030bc89a4250e63d16b082affe1998618c3f": "e4299c419434fc51f64a5266659918fa",
".git/objects/7b/0c5d2dcb0c895abf2f78d2f40390ce26a673b7": "ff66e6a8a0c5c0d6c8fb97dce0869611",
".git/objects/80/c4a96f8f66e5e0c255db6da33ee8ccb53097d0": "a5b74c75d0d9c57515a755fd30e2daf0",
".git/objects/82/37cbb63a838ebd51e19b7a5f72f271deb773cc": "8bb3cd8e8ca5579de448b1c73b3c1579",
".git/objects/82/8009dfeed74d0d0288d81718a25038b0a555b0": "b939d4d712b707c433251974082cf5a7",
".git/objects/83/2346302c01dd92d5b345a2a49a7173018943dc": "a95e4b109da2dfb74e7b23705f721591",
".git/objects/83/a9e60a356425cc01858aaa96da4244d52be662": "fa08d9dbd0866eb5c78b3b05eba67862",
".git/objects/83/b9df7277f87b15150b81202780689fb5c45da3": "d113af668683ecbba11095bcfc1fbfca",
".git/objects/84/c5b651b72a70d96f833125783821a4198c104f": "0b6d108ddf0be99b00045a618f77662e",
".git/objects/86/262b72b279dde9b9cff35fa647373a67d2b516": "759055e00c0a46ceb3773ce4a7bacf62",
".git/objects/86/5754b00fa71c3d8b975808434272b17fe5e2e1": "e2e59ba0be55d92977c6494072556421",
".git/objects/86/b6c159cb518bcd4b1c1685d2793652f23dd6f8": "afaf57ac55951b2880f5baacbdf8cf81",
".git/objects/86/d111f09a93cccfa0011858c519a823e7dafef7": "9a15839a59b5f501fbf7b9824c4b6f84",
".git/objects/88/4410b68636ae928901ed9e5f4a0f9d9d81c071": "ffc646423e8ac65a4e7ccf08d12ee7a1",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/51a9b155d31c44b148d7e287fc2872e0cafd42": "9f785032380d7569e69b3d17172f64e8",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8f/368292a70675725b4d450fb31a7af7e7a2465c": "f772b016eabfd2336c517d3cfb18602d",
".git/objects/8f/894abdf4f928b4a1e9790134902e64d7e3dca5": "1fd69116335ccbc69aabfc52ac8473d4",
".git/objects/8f/c8be62f202c40e7d3e2e16242fb065cfc4e1a7": "6fda1b80da67a8d96186cf8ab8b24087",
".git/objects/91/4a40ccb508c126fa995820d01ea15c69bb95f7": "8963a99a625c47f6cd41ba314ebd2488",
".git/objects/98/02b28256772837d6941a9275525852cf9579a0": "056742ad4504325088558ce9d9444777",
".git/objects/9e/1c8f41c7e28ff48b28cea73103535845ff98b2": "54016068a3c2f0af69b1f835d550e909",
".git/objects/9e/26dfeeb6e641a33dae4961196235bdb965b21b": "304148c109fef2979ed83fbc7cd0b006",
".git/objects/a1/19bc25407442a3a33aec98780ab5955c1ae6fc": "b53f9755da47cec4f09481350555d00c",
".git/objects/a5/de584f4d25ef8aace1c5a0c190c3b31639895b": "9fbbb0db1824af504c56e5d959e1cdff",
".git/objects/a6/1a2d17579148386dc147f09c2e230ff38cc09d": "59d948a6135d6528dbf65a12f5b0bdc6",
".git/objects/a8/8c9340e408fca6e68e2d6cd8363dccc2bd8642": "11e9d76ebfeb0c92c8dff256819c0796",
".git/objects/ad/879f94728a394a5394ee86d32d226dc16469fb": "145d65c9e31613ef9c5e253439328f9c",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/bc/30cc6671be3580c256c8d618cadb3030d9c8fb": "25a2bb498a37d71a39b17088aee0eb71",
".git/objects/bf/d141601a7945c193d9100ce02ebf3f148bc7cf": "49f9995307311cc614509c37205f61f2",
".git/objects/c2/12d24433072f309e4611797d2a93ef62972d3f": "f82d2afcff054745be7894710022bd91",
".git/objects/c4/60fbb74f6fb66b64679f604319eb10f7705396": "a78cdb66560c92e11e46c4af30d16b46",
".git/objects/ce/51a994664b041b32b4e35e49c5993fd4852d82": "f2d1cc0fb58ef1881f80e8167ffa0eea",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d9/3952e90f26e65356f31c60fc394efb26313167": "1401847c6f090e48e83740a00be1c303",
".git/objects/db/83455117e8c9b201fd45fdab31770d43f1d862": "23c31c31915b61a020addfe851d5b99c",
".git/objects/e2/3904318c892a8d0188371b2645618fc94e97c3": "b93d065bfda878599d48c50497822dea",
".git/objects/e2/5bb1eb0c8d6f06841c5b2aeef79b7b7d88fad0": "15ae42deaa7d50b053e75239fae043b5",
".git/objects/e5/c394d66978d6d3b27edbc47dfba4a4b9cfb7b6": "564becab5248dc6b20a785cddf8b7d66",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ed/82c307ef3e3527fdb0edb410bcd5f258809463": "2123766b19de595a2c06972d021b12a3",
".git/objects/ee/8b72f51015219cecd5478a024d9511be2fc18d": "25d1fb7a0403804df9cd7dac17f434c5",
".git/objects/ef/8497ee2b5b788d9381cb463db59d5dd4cbae99": "10792d4f2feda8b37217649ee9c1974a",
".git/objects/ef/b875788e4094f6091d9caa43e35c77640aaf21": "27e32738aea45acd66b98d36fc9fc9e0",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f3/709a83aedf1f03d6e04459831b12355a9b9ef1": "538d2edfa707ca92ed0b867d6c3903d1",
".git/objects/f7/75ce2c66fde148e29b52d2a9610f3b436bf477": "9c650be9231572fc9fe59b4dfef4f36d",
".git/refs/heads/master": "50fa3602557e4244e9414f53c3a363ba",
".git/refs/remotes/origin/gh-pages": "50fa3602557e4244e9414f53c3a363ba",
"assets/AssetManifest.bin": "0b0a3415aad49b6e9bf965ff578614f9",
"assets/AssetManifest.bin.json": "a1fee2517bf598633e2f67fcf3e26c94",
"assets/AssetManifest.json": "99914b932bd37a50b983c5e7c90ae93b",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "e7cf04df944269d3b9adcd93331d614d",
"assets/NOTICES": "d21d8662597e2774c93eb97ec1c91484",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "d6bfdbe78b3396a66915ee2eeb7b5702",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "706a54c6cc672e82882f6f2754c46a0b",
"icons/Icon-192.png": "bd711c4d5e14cd4a5cbc6c508540e664",
"icons/Icon-512.png": "e3cc8969176caf83777b38412d887dcd",
"icons/Icon-maskable-192.png": "bd711c4d5e14cd4a5cbc6c508540e664",
"icons/Icon-maskable-512.png": "e3cc8969176caf83777b38412d887dcd",
"index.html": "7ef07c7bf76c20d21b5912320e89b954",
"/": "7ef07c7bf76c20d21b5912320e89b954",
"main.dart.js": "21724fb55fc1a08d24f35a3c2adc690c",
"manifest.json": "be6be3cee599f27d8714e181cb53c5b7",
"version.json": "4b7d82800be778adfdf2c6a376b38022"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

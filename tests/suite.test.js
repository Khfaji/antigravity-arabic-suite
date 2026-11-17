const assert = require('assert');
const fs = require('fs');
const path = require('path');
const vm = require('vm');

const rootDir = path.resolve(__dirname, '..');
const srcDir = path.join(rootDir, 'src');

console.log('=== Antigravity Arabic Suite Automated Tests ===');

// 1. Syntax & VM compilation checks
const { INJECT_CODE } = require(path.join(srcDir, 'inject.js'));
assert.ok(typeof INJECT_CODE === 'string' && INJECT_CODE.length > 10000, 'INJECT_CODE must be non-empty string');
new vm.Script(INJECT_CODE);
console.log('[PASS] inject.js INJECT_CODE compiles cleanly');

for (const file of ['antigravity-ide-rtl.js', 'git-branch-widget.js', 'service.js']) {
  const code = fs.readFileSync(path.join(srcDir, file), 'utf8');
  new vm.Script(code);
  console.log(`[PASS] ${file} compiles cleanly`);
}

// 2. Security checks on service.js
const serviceCode = fs.readFileSync(path.join(srcDir, 'service.js'), 'utf8');
assert.ok(!serviceCode.includes("'Access-Control-Allow-Origin', '*'"), 'service.js must not use wildcard CORS');
assert.ok(!serviceCode.includes("'Access-Control-Allow-Origin': '*'"), 'service.js must not use wildcard CORS header');
assert.ok(serviceCode.includes("127.0.0.1"), 'service.js must bind to loopback 127.0.0.1');
assert.ok(serviceCode.includes('x-antigravity-token'), 'service.js must enforce X-Antigravity-Token');
assert.ok(serviceCode.includes('BEGIN PUBLIC KEY'), 'service.js must embed Ed25519 public key');
console.log('[PASS] service.js security controls verified');

// 3. Brand attribution & integrity checks
assert.ok(INJECT_CODE.includes('Eng. Mohamed') && INJECT_CODE.includes('t.me/khfaji'), 'inject.js must preserve author attribution');
const ideCode = fs.readFileSync(path.join(srcDir, 'antigravity-ide-rtl.js'), 'utf8');
assert.ok(ideCode.includes('Eng. Mohamed') && ideCode.includes('t.me/khfaji'), 'antigravity-ide-rtl.js must preserve author attribution');
console.log('[PASS] Brand attribution & integrity checks passed');

// 4. Version metadata check
const ver = JSON.parse(fs.readFileSync(path.join(rootDir, 'version.json'), 'utf8'));
assert.ok(/^\d+\.\d+\.\d+$/.test(ver.version), 'version.json version must be valid semver');
assert.ok(Number.isInteger(ver.build) && ver.build >= 1, 'version.json build must be positive integer');
assert.ok(Array.isArray(ver.changelog) && ver.changelog.length > 0, 'version.json changelog must be non-empty');
console.log(`[PASS] version.json valid: v${ver.version} (Build ${ver.build})`);

console.log('ALL TESTS PASSED!');

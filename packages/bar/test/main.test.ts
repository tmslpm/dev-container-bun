import { describe, expect, it } from "bun:test";
import packageJSON from "../package.json" with { type: "json" };
import { APP_ID, APP_VERSION } from "../src/main";

describe("main", () => {
	it("expose la version du package.json", () => {
		expect(APP_VERSION).toBe(packageJSON.version);
	});

	it("construit APP_ID à partir du nom et de la version", () => {
		expect(APP_ID).toBe(`${packageJSON.name}+${packageJSON.version}`);
	});
});

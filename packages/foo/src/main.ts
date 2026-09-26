import packageJSON from "../package.json" with { type: "json" };

export const APP_VERSION = packageJSON.version;

export const APP_ID = `${packageJSON.name}+${APP_VERSION}`;

export default function main() {
	console.log({ APP_ID });
}

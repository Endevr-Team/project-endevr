# Endevr App

## Developing

To install dependencies:

```bash
yarn
```

To start the development server:

```bash
yarn dev

# or start the server and open the app in a new browser tab
yarn dev -- --open
```

Before merging to master please make sure the linter is not complaining:

```bash
yarn lint
```

## Building

To create a production version of the app:

```bash
yarn build
```

You can preview the production build with `yarn preview`.

<!-- > To deploy your app, you may need to install an [adapter](https://kit.svelte.dev/docs/adapters) for your target environment. -->

<script lang="ts">
  import type { Pioneer } from '$lib/session';
  import Avatar from './Avatar.svelte';

  export let title: string;
  export let mission: string;
  export let image: string;
  export let pioneer: Pioneer;
</script>

<section class="paper paper">
  <img class="header" src={image} alt={title} />
  <h3>{title}</h3>
  <p class="mission">{mission}</p>
  <div class="card-info">
    <Avatar user={pioneer} size={3} />
    <span class="name">{pioneer.firstName} {pioneer.lastName}</span>
  </div>
</section>

<style lang="scss">
  section {
    display: flex;
    flex-direction: column;
    margin: 1rem;
    border: solid 1.5px rgba(#a8a8a8, 23%);
    border-radius: 5px;
    width: 27rem;
    height: 20rem;
    overflow: hidden;

    :not(.header) {
      margin-left: 0.5rem;
      margin-right: 0.5rem;
    }
    * {
      margin-bottom: 0.25rem;
    }

    .header {
      height: 60%;
      object-fit: cover;
    }
    .mission {
      color: var(--secondary-text-color);
    }
  }

  .card-info {
    display: flex;
    flex-direction: row;
    color: var(--secondary-text-color);

    .name {
      margin-top: 0.75rem;
      width: calc(28rem);
      height: calc(20rem);
      overflow: hidden;
    }

      .header-img {
        height: 60%;
        object-fit: cover;
      }

      :not(.header-img) {
        margin: 0 0.5rem;
      }

      * {
        margin-bottom: 0.5rem;
      }
  }

</style>

<script lang="ts">
  import type { User } from '$lib/session';

  export let user: User;
  export let size: number;
</script>

<div class="container" style="--size: {size}rem">
  <img
    class="avatar"
    src={user.avatarUrl}
    alt={`${user.firstName} ${user.lastName}`}
    on:click
  />
</div>

<style lang="scss">
  .container {
    display: flex;
    height: var(--size);
    width: var(--size);
    border-radius: 50%;
    overflow: hidden;
    margin: 0.5rem;
  }
  .avatar {
    flex: 1;
    object-fit: cover;
  }
</style>

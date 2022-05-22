<script lang="ts">
  export let title: string;
  export let mission: string;
  export let image: string;
</script>

<section>
  <img class="header-img" src={image} alt={title} />
  <h4>{title}</h4>
  <p>{mission}</p>
</section>

<style lang="scss">
  section {
    display: flex;
    flex-direction: column;
    margin: 1rem;
    border: solid 1.5px rgba(#a8a8a8, 23%);
    border-radius: 5px;
    width: calc(28rem);
    height: calc(20rem);
    overflow: hidden;

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

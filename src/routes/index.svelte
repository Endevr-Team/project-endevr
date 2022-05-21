<script lang="ts">
	import ListingCard from '$lib/ListingCard.svelte';
	import Header from '../lib/components/Header.svelte';

	const cards = [
		{
			id: 1,
			title: 'Using ZK for game optimization in Dark Forest',
			mission:
				'We believe everyone Lorem ipsum dolor sit amet, consectetur adipiscing elit. Egestas sit turpis vel a.',
			image:
				'https://c.gitcoin.co/grants/ac49910ab6c4693df8c68a71a98fe14b/0000001.png'
		},
		{
			id: 2,
			title: 'Using ZK for game optimization in Dark Forest',
			mission:
				'We believe everyone Lorem ipsum dolor sit amet, consectetur adipiscing elit. Egestas sit turpis vel a.',
			image:
				'https://c.gitcoin.co/grants/efa9d89ad3b641b2485536b6d4d710c3/130274396-5b016393-d6f2-4eba-9660-92a2983c8dd5.jpeg'
		}
	];
</script>


<Header/>

{#each cards as card (card.id)}
	<ListingCard {...card} />
{/each}





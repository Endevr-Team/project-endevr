<script>
    let chainlink_src = 'frontend/static/chainlink-logo.png';
    let filecoin_src = 'frontend/static/filecoin-logo.png';
    let moralis_src = 'frontend/static/moralis-logo.png';
</script>

<footer>
    <p> Powered by: </p>
    <div class="div">
        <img src={chainlink_src} alt="chainlink logo" width="100px" height="100px"/>
        <img src={filecoin_src} alt="filecoin logo" width="100px" height="100px"/>
        <img src={moralis_src} alt="moralis logo" width="100px" height="100px"/>
    </div>
</footer>

<style>
    footer{
        align-items: center;
        display: flex;
        background-color: #FCFCFC;
        height: 10rem;
    }

    .div{
        display: flex;
        flex-direction: row;
    }
</style>
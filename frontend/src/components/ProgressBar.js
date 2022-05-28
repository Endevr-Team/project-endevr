const ProgressBar = (props) => {
    const { bgcolor, completed } = props;

    const containerStyles = {
        height: 30,
        width: '100%',
        backgroundColor: "#e0e0de",
        borderRadius: 5,
        marginTop: 30
    }

    const fillerStyles = {
        height: '100%',
        width: `${completed}%`,
        transition: 'width 1s ease-in-out',
        backgroundColor: "#000",
        borderRadius: 'inherit',
        textAlign: 'right'

    }

    const labelStyles = {
        paddingRight: 5,
        lineHeight: "30px",
        color: 'white',
        fontWeight: 'bold'
    }

    return (
        <div style={containerStyles}>
            <div style={fillerStyles}>
                <span style={labelStyles}>{`${completed}%`}</span>
            </div>
        </div>
    );
};

export default ProgressBar;

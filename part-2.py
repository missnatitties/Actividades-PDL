import dash
from dash import dcc
from dash import html
from dash.dependencies import Input, Output

app = dash.Dash(__name__)

app.layout = html.Div([
    html.Div([
        "Input: ",
        dcc.Input(id='exponente', value='0', type='text')
    ]),
    html.Br(),
    html.Div(id='resultado'),
])


@app.callback(
    Output(component_id='resultado', component_property='children'),
    Input(component_id='exponente', component_property='value')
)
def update_output_div(input_value):
    return f'Resultado: {2**float(input_value)}'


if __name__ == '__main__':
    app.run_server(debug=True)